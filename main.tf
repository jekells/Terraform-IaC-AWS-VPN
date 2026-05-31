terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "vpn_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = { Name = "cloudvpn-vpc" }
}

# Internet gateway
resource "aws_internet_gateway" "vpn_igw" {
  vpc_id = aws_vpc.vpn_vpc.id
  tags = { Name = "cloudvpn-igw" }
}

# Public subnet
resource "aws_subnet" "vpn_subnet" {
  vpc_id                  = aws_vpc.vpn_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = { Name = "cloudvpn-subnet" }
}

# Route table
resource "aws_route_table" "vpn_rt" {
  vpc_id = aws_vpc.vpn_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpn_igw.id
  }
}

resource "aws_route_table_association" "vpn_rta" {
  subnet_id      = aws_subnet.vpn_subnet.id
  route_table_id = aws_route_table.vpn_rt.id
}

# SSH key pair
resource "aws_key_pair" "vpn_key" {
  key_name   = "cloudvpn-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# EC2 instance
resource "aws_instance" "vpn_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.vpn_subnet.id
  vpc_security_group_ids = [aws_security_group.vpn_sg.id]
  key_name               = aws_key_pair.vpn_key.key_name
  user_data              = templatefile("templates/wg-init.tpl", {
    wg_port = var.wg_port
  })
  tags = { Name = "cloudvpn-server" }
}
