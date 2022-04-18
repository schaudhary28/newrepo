

output "alb_dns_name" {
  description = "Load balancer DNS"
  value       = module.alb.alb_dns_name
}