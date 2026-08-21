module "vpc" {
  source              = "./modules/vpc"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "internet_gateway" {
  source       = "./modules/internet-gateway"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

module "public_route_table" {
  source              = "./modules/public-route-table"
  vpc_id              = module.vpc.vpc_id
  project_name        = var.project_name
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  public_subnet_ids   = module.vpc.public_subnet_ids
}

module "secuirty_group" {
  source             = "./modules/security-group"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  custom_tcp_port    = var.custom_tcp_port
  allowed_cidr_block = ["0.0.0.0/0"]
}

data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

module "ec2" {
  source            = "./modules/ec2"
  project_name      = var.project_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.secuirty_group.security_group_id
  key_name          = var.key_name
}

module "ecr" {
  source               = "./modules/ecr"
  repository_name      = "user-management-service"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  encryption_type      = "AES256"
}

module "eks_cluster" {
  source          = "./modules/eks-cluster"
  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  subnet_ids = module.vpc.public_subnet_ids

  security_group_ids = [
    module.secuirty_group.security_group_id
  ]
}

module "eks_node_group" {
  source = "./modules/eks-node-group"

  cluster_name    = module.eks_cluster.cluster_name
  node_group_name = var.eks_node_group_name

  instance_types = var.eks_instance_types

  subnet_ids = module.vpc.public_subnet_ids

  desired_size = var.eks_desired_size
  min_size     = var.eks_min_size
  max_size     = var.eks_max_size

  disk_size = var.eks_disk_size

  depends_on = [
    module.eks_cluster
  ]
}
