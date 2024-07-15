output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = ""
  value = module.eks.cluster_certificate_authority_data
}

# output "cluster_name" {
#   description = "Cluster name"
#   value = "booking-app-sg6-cluster"
# }