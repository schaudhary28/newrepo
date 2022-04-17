# Add output variables

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "alb_dns_name" {
  description = "Load balancer's DNS"
  value       = module.alb.alb_dns_name
}
