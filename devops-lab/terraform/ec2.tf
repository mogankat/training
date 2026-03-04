# ── HAProxy (Load Balancer) ───────────────────────────────────────────────

resource "aws_instance" "haproxy" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.lb.id]
  key_name               = aws_key_pair.lab.key_name

  tags = { Name = "${var.project}-haproxy", Role = "load_balancer", Project = var.project }
}

# Elastic IP: a static IP that survives stop/start cycles
resource "aws_eip" "haproxy" {
  instance = aws_instance.haproxy.id
  domain   = "vpc"

  tags = { Name = "${var.project}-haproxy-eip", Project = var.project }
}

# ── Web Servers ───────────────────────────────────────────────────────────

# count = 2 creates webapp[0] and webapp[1]
resource "aws_instance" "webapp" {
  count                  = var.webapp_count
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.lab.key_name

  tags = {
    Name    = "${var.project}-webapp${count.index + 1}"
    Role    = "web_server"
    Project = var.project
  }
}

# ── Monitoring Server ─────────────────────────────────────────────────────

resource "aws_instance" "monitoring" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.monitoring.id]
  key_name               = aws_key_pair.lab.key_name

  # Larger root volume: Prometheus stores metrics, Loki stores logs
  root_block_device {
    volume_size = 30    # GB (AL2023 snapshot minimum; extra space for metrics/logs)
    volume_type = "gp3"
  }

  tags = { Name = "${var.project}-monitoring", Role = "monitoring", Project = var.project }
}

resource "aws_eip" "monitoring" {
  instance = aws_instance.monitoring.id
  domain   = "vpc"

  tags = { Name = "${var.project}-monitoring-eip", Project = var.project }
}