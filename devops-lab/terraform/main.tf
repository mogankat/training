terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Automatically find the latest Amazon Linux 2023 AMI in the current region
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ── VPC ────────────────────────────────────────────────────────────────────

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true  # Required for EC2 hostnames to resolve

  tags = { Name = "${var.project}-vpc", Project = var.project }
}

# Internet Gateway: allows the VPC to send/receive internet traffic
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = { Name = "${var.project}-igw", Project = var.project }
}

# Public subnet: instances here get a public IP and can reach the internet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true  # Auto-assign public IP to instances

  tags = { Name = "${var.project}-public", Project = var.project }
}

# Route table: sends all non-local traffic to the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = { Name = "${var.project}-public-rt", Project = var.project }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# SSH key pair: upload your public key so EC2 instances accept it
resource "aws_key_pair" "lab" {
  key_name   = "${var.project}-key"
  public_key = file(var.ssh_public_key_path)

  tags = { Project = var.project }
}