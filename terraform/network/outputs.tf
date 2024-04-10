output "node_security_group_id" {
  description = "The ID of the EKS node security group"
  value       = aws_security_group.eks_worker_sg.id
}

output "booking_sg6_subnet1_id" {
  description = ""
  value       = aws_subnet.booking_sg6_subnet1.id
}

output "booking_sg6_subnet2_id" {
  description = ""
  value       = aws_subnet.booking_sg6_subnet2.id
}

output "booking_sg6_vpc_id" {
  description = ""
  value       = aws_vpc.booking_sg6_vpc.id
}