variable "bucket_name" {
    default = "fritzhomelab-backend-bucket005" 
}
variable "dynamodb_name" {
    default = "fritzhomelab-terraform-locking"
}

variable "region" {
    default = "us-east-1"
}

variable vpc_cidr {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"   
}

variable az1 {
  description = "The first availability zone"
  type        = string
  default     = "us-east-1a"
}

variable az2 {
  description = "The second availability zone"
  type        = string
  default     = "us-east-1b"
}

variable instance_type {
  description = "The instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}