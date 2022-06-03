output "default_target_group_arn" {
  description = ""
  value = aws_alb_target_group.default.arn
}

output "dns_name" {
  description = "loadbalancer dns name"
  value = aws_alb.ping_server_loadbalancer.dns_name
}

output "loadbalancer_security_group_id" {
  description = ""
  value = aws_security_group.loadbalancer.id
}
