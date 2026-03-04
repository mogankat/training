locals {
  # Restrict admin ports to your workstation only
  my_cidr = "${var.my_ip}/32"
}

# ── Load Balancer Security Group ──────────────────────────────────────────

resource "aws_security_group" "lb" {
  name        = "${var.project}-lb-sg"
  description = "HAProxy load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HAProxy stats page"
    from_port   = 8404
    to_port     = 8404
    protocol    = "tcp"
    cidr_blocks = [local.my_cidr]
  }

  ingress {
    description = "SSH from workstation"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-lb-sg", Project = var.project }
}

# ── Web Server Security Group ─────────────────────────────────────────────

resource "aws_security_group" "web" {
  name        = "${var.project}-web-sg"
  description = "nginx web servers"
  vpc_id      = aws_vpc.main.id

  # Only accept web traffic from the load balancer — not directly from internet
  ingress {
    description     = "HTTP from load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    description = "SSH from workstation (Ansible)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-web-sg", Project = var.project }
}

# ── Monitoring Security Group ─────────────────────────────────────────────

resource "aws_security_group" "monitoring" {
  name        = "${var.project}-monitoring-sg"
  description = "Prometheus, Grafana, Loki"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Grafana dashboard"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [local.my_cidr]
  }

  ingress {
    description = "Prometheus UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [local.my_cidr]
  }

  # Promtail on the web/lb servers ships logs to Loki over the VPC network
  ingress {
    description     = "Loki from web servers"
    from_port       = 3100
    to_port         = 3100
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id, aws_security_group.lb.id]
  }

  ingress {
    description = "SSH from workstation"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-monitoring-sg", Project = var.project }
}