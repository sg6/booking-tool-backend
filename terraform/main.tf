#provider.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
    shared_credentials_files = ["/home/stefan/.aws/credentials-booking-app-user"]
    profile = "booking-app-user"
}

#vpc.tf

resource "aws_vpc" "booking_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "booking_vpc"
  }
}

resource "aws_subnet" "booking_subnet_1" {
  vpc_id     = aws_vpc.booking_vpc.id
  cidr_block = "10.0.1.0/24"
  #availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "booking_subnet_1"
  }
}

resource "aws_subnet" "booking_subnet_2" {
  vpc_id     = aws_vpc.booking_vpc.id
  cidr_block = "10.0.2.0/24"
  #availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "booking_subnet_2"
  }
}

#data "aws_subnets" "booking_subnets" {
#  filter {
#    name   = "vpc-id"
#    values = [aws_vpc.booking_vpc.id]
#  }
#}
#
#data "aws_subnet" "booking_subnet" {
#  for_each = toset(data.aws_subnets.booking_subnets.ids)
#  id       = each.value
#}
#
#output "subnet_cidr_blocks" {
#  value = [for s in data.aws_subnet.booking_subnet : s.cidr_block]
#}

#eks.tf

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "booking-app-sg6-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true

  vpc_id = aws_vpc.booking_vpc.id

  subnet_ids = [aws_subnet.booking_subnet_1.id, aws_subnet.booking_subnet_2.id]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    example = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::123456789012:role/something"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}