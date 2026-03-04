variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Name prefix for all resources (used in tags and names)"
  type        = string
  default     = "devops-lab"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for all servers"
  type        = string
  default     = "t3.micro"
}

variable "webapp_count" {
  description = "Number of web server instances to create"
  type        = number
  default     = 2
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key file"
  type        = string
  default     = "~/.ssh/devops-lab.pub"
}

variable "my_ip" {
  description = "Your workstation's public IP (restricts SSH and admin port access)"
  type        = string
  # Get your IP: curl -s https://checkip.amazonaws.com
}