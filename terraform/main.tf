#provider.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    flux = {
      source = "fluxcd/flux"
      version = "1.3.0"
    }

    github = {
      source  = "integrations/github"
      version = ">= 6.1"
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

module "flux" {
  source = "./flux"
}

provider "flux" {
  kubernetes = {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    config_path = "~/.kube/mentorship.config"
  }
  git = {
    url = "https://github.com/${module.flux.github_org}/${module.flux.github_repo}.git"
    http = {
      username = "git" # This can be any string when using a personal access token
      password = module.flux.github_token
    }
  }
}

resource "github_repository" "this" {
  name        = module.flux.github_repo
  description = module.flux.github_repo
  visibility  = "public"
  auto_init   = true # This is extremely important as flux_bootstrap_git will not work without a repository that has been initialised
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository.this]

  embedded_manifests = true
  path               = "tooling/flux-system"
}

provider "github" {
  owner = module.flux.github_org
  token = module.flux.github_token
}