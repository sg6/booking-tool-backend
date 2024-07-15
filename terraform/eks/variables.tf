variable "node_security_group_id" {
  description = "The ID of the security group for the EKS worker nodes"
  type        = string
}

variable "iam_instance_profile_name" {
  description = ""
  type        = string
}

variable "booking_sg6_eks_cluster_name" {
  description = ""
  type        = string
}

variable "booking_sg6_eks_worker_name" {
  description = ""
  type        = string
}

variable "booking_sg6_subnet1_id" {
  description = ""
  type        = string
}

variable "booking_sg6_subnet2_id" {
  description = ""
  type        = string
}

variable "booking_sg6_vpc_id" {
  description = ""
  type        = string
}

# variable "cluster_name" {
#   description = "Cluster name"
#   type        = string
# }