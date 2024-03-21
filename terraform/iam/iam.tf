resource "aws_iam_role" "booking_sg6_eks_worker" {
  name = "eks-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role" "booking_sg6_eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = "",
    }],
  })
}

resource "aws_iam_role_policy_attachment" "booking_sg6_eks_cluster_policy" {
  role       = aws_iam_role.booking_sg6_eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "booking_sg6_eks_service_policy" {
  role       = aws_iam_role.booking_sg6_eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# Attach the AmazonEKSWorkerNodePolicy policy
resource "aws_iam_role_policy_attachment" "booking_sg6_eks_worker_node" {
  role       = aws_iam_role.booking_sg6_eks_worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach the AmazonEC2ContainerRegistryReadOnly policy
resource "aws_iam_role_policy_attachment" "booking_sg6_eks_worker_crr" {
  role       = aws_iam_role.booking_sg6_eks_worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Attach the AmazonEKS_CNI_Policy policy
resource "aws_iam_role_policy_attachment" "booking_sg6_eks_cni" {
  role       = aws_iam_role.booking_sg6_eks_worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_instance_profile" "booking_sg6_eks_worker" {
  name = "eks-worker-instance-profile"
  role = aws_iam_role.booking_sg6_eks_worker.name
}