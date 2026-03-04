output "haproxy_public_ip" {
  description = "Public IP of the load balancer (point your browser here)"
  value       = aws_eip.haproxy.public_ip
}

output "webapp_public_ips" {
  description = "Public IPs of the web servers (for Ansible)"
  value       = aws_instance.webapp[*].public_ip
}

output "monitoring_public_ip" {
  description = "Public IP of the monitoring server (Grafana, Prometheus)"
  value       = aws_eip.monitoring.public_ip
}

output "ssh_commands" {
  description = "Ready-to-use SSH commands for each server"
  value = {
    haproxy    = "ssh -i ~/.ssh/devops-lab ec2-user@${aws_eip.haproxy.public_ip}"
    webapp1    = "ssh -i ~/.ssh/devops-lab ec2-user@${aws_instance.webapp[0].public_ip}"
    webapp2    = "ssh -i ~/.ssh/devops-lab ec2-user@${aws_instance.webapp[1].public_ip}"
    monitoring = "ssh -i ~/.ssh/devops-lab ec2-user@${aws_eip.monitoring.public_ip}"
  }
}

# Generates a ready-to-paste Ansible inventory
output "ansible_inventory" {
  description = "Paste this into ansible/inventory/hosts.ini"
  value = <<-EOT
    [load_balancers]
    ${aws_eip.haproxy.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/devops-lab

    [web_servers]
    ${aws_instance.webapp[0].public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/devops-lab
    ${aws_instance.webapp[1].public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/devops-lab

    [monitoring]
    ${aws_eip.monitoring.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/devops-lab
  EOT
}