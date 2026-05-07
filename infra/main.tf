cat <<EOF > main.tf
provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "devops-vpc"
  }
}
#This block creates a custom VPC for isolating project infrastructure.

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "devops-subnet"
  }
}
#Public subnet allows EC2 instance to access internet.

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "devops-igw"
  }
}

#Internet Gateway enables communication between VPC and internet.

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

#Route table directs external traffic through Internet Gateway.

# Route Table Association
resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#Associates public subnet with public route table.

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

#Security group allows SSH and HTTP traffic to EC2 instance.

# EC2 Instance
resource "aws_instance" "app_server" {
  ami           = "ami-0f58b397bc5c1f2e8"  # Ubuntu 22.04 (Mumbai)
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name      = var.key_name

  tags = {
    Name = "devops-ec2"
  }
}

#This block creates Ubuntu EC2 instance with public IP and security group.

# Elastic IP
resource "aws_eip" "elastic_ip" {
  instance = aws_instance.app_server.id
}

#fixed permanent IP.Attaches Elastic IP to EC2.
EOF
