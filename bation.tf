data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_key_pair" "bastion_key" {
  key_name = "new-keypair"
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_1.id
  key_name                    = data.aws_key_pair.bastion_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-instance"
  }
}