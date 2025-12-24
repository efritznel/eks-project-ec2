output "endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = "${aws_eks_cluster.my-eks-cluster.endpoint}"
}