resource "aws_security_group" "worker_nodes_sg" {
  name        = "eks-test"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow ssh inbound traffic from within the security group"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}