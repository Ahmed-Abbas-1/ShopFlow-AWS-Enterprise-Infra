module "vpc" {
  source = "../../modules/vpc"

  environment = "dev"
  
  # We are relying on the default variables (CIDR and subnets) defined in the module.
  # If we need different IP ranges for 'prod', we can override them here.
}

module "rds" {
  source = "../../modules/rds"

  environment        = "dev"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = "10.0.0.0/16"
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "iam" {
  source = "../../modules/iam"

  environment = "dev"
}

module "eks" {
  source = "../../modules/eks"

  environment      = "dev"
  subnet_ids       = module.vpc.private_subnet_ids
  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn
}

module "ecr" {
  source = "../../modules/ecr"

  environment = "dev"
}
