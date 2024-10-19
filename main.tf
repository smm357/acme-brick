# Import the network module
module "network" {
  source      = "./modules/network"
  aws_region  = var.aws_region
  environment = var.environment
  project     = var.project_name
}

# Import the security module
module "security" {
  source          = "./modules/security"
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets
  environment     = var.environment
  project         = var.project_name
}

# Import the compute modules
module "ec2" {
  source          = "./modules/compute/ec2"
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  environment     = var.environment
  project         = var.project_name
}

module "ecs" {
  source          = "./modules/compute/ecs"
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  environment     = var.environment
  project         = var.project_name
}

module "lambda" {
  source          = "./modules/compute/lambda"
  environment     = var.environment
  project         = var.project_name
}

# Import the database module
module "database" {
  source          = "./modules/database"
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  environment     = var.environment
  project         = var.project_name
  db_password     = var.db_password
}

# Import the storage module
module "storage" {
  source      = "./modules/storage"
  environment = var.environment
  project     = var.project_name
}

# Import the CI/CD module
module "ci_cd" {
  source      = "./modules/ci_cd"
  environment = var.environment
  project     = var.project_name
  github_repo = var.github_repo
}

# Import the monitoring module
module "monitoring" {
  source      = "./modules/monitoring"
  environment = var.environment
  project     = var.project_name
}

# Additional modules as needed
