#provider.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "aws" {
    region = "us-east-1"
    shared_credentials_files = ["/home/stefan/.aws/credentials-booking-app-user"]
    profile = "booking-app-user"
}

module "network" {
  source = "./network"
  # variables...
}

module "iam" {
  source = "./iam"
}

module "eks" {
  source = "./eks"

  #variables
  node_security_group_id  = module.network.node_security_group_id
  iam_instance_profile_name = module.iam.iam_instance_profile_name
  booking_sg6_eks_cluster_name = module.iam.aws_iam_role_booking_sg6_eks_worker
  booking_sg6_eks_worker_name = module.iam.booking_sg6_eks_worker_name
  booking_sg6_subnet1_id = module.network.booking_sg6_subnet1_id
  booking_sg6_subnet2_id = module.network.booking_sg6_subnet2_id
  booking_sg6_vpc_id = module.network.booking_sg6_vpc_id
}