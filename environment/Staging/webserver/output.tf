
output "alb_dns_name" {
  description = "load balancer's DNS"
  value       = module.alb.alb_dns_name
}

