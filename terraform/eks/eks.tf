module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "booking-app-sg6-cluster"
  cluster_version = "1.29"

  cluster_endpoint_private_access = true # default value, for better overview
  cluster_endpoint_public_access  = true

  enable_irsa = true

  vpc_id = aws_vpc.booking_sg6_vpc.id

  subnet_ids = [aws_subnet.booking_sg6_subnet1.id, aws_subnet.booking_sg6_subnet2.id]

  iam_role_name = aws_iam_role.booking_sg6_eks_cluster.name

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    booking_sg6_ng1 = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      iam_instance_profile_name = aws_iam_instance_profile.booking_sg6_eks_worker.name

      node_security_group_id = aws_security_group.eks_worker_sg.id
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}