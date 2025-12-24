variable "sg_ids" {
type = string
}

/* variable "subnet_ids" {
  type = list
} */

variable "vpc_id" {
  type = string
} 

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for EKS control plane and node group"
}