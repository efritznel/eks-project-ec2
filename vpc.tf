# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-vpc"
  }
}

# Create 4 Subnets 2 public and 2 private in different AZs
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
    availability_zone       = var.az2
    map_public_ip_on_launch = true
    tags = {
    Name = "public-subnet-2"
    }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
    availability_zone = var.az1
    tags = {
    Name = "private-subnet-1"
    }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
    availability_zone = var.az2
    tags = {
    Name = "private-subnet-2"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public-rt"
  }
}
# Create Route to Internet Gateway in Public Route Table
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id    
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Create elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# Create NAT Gateway in Public Subnet 1
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "nat-gw"
  }
}

# Create Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "private-rt"
  }
}

# Create Route to NAT Gateway in Private Route Table
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_1_assoc" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_2_assoc" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

# Modules for EKS Security Groups and EKS Cluster
module "sgs" {
  source = "./eks-sg"
    vpc_id = aws_vpc.my_vpc.id
}

module "eks" {
  source          = "./eks"
  vpc_id          = aws_vpc.my_vpc.id
  # subnet_ids       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  private_subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  sg_ids = module.sgs.security_group_public
}