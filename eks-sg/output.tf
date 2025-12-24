output "security_group_public" {
  description = "The security group ID for the EKS cluster"
  value       = "${aws_security_group.worker_nodes_sg.id}"
}