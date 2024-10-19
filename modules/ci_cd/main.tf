# CodeBuild Project
resource "aws_codebuild_project" "build" {
  name          = "${var.project}-${var.environment}-build"
  description   = "CodeBuild project for ${var.project}"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }
  }

  source {
    type            = "GITHUB"
    location        = var.github_repo
    buildspec       = "buildspec.yml"
  }

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# CodeDeploy Application and Deployment Group
resource "aws_codedeploy_app" "app" {
  name = "${var.project}-${var.environment}-codedeploy-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = "${var.project}-${var.environment}-deployment-group"

  service_role_arn = aws_iam_role.codedeploy_role.arn

  deployment_config_name = "CodeDeployDefault.OneAtATime"

  autoscaling_groups = [module.ec2.ec2_asg_name]

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# CodePipeline
resource "aws_codepipeline" "pipeline" {
  name     = "${var.project}-${var.environment}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.general_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = aws_codecommit_repository.repo.name
        BranchName     = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group_name
      }
    }
  }

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# IAM Roles for CodeBuild, CodeDeploy, and CodePipeline
# Define aws_iam_role.codebuild_role, aws_iam_role.codedeploy_role, and aws_iam_role.codepipeline_role with appropriate policies
