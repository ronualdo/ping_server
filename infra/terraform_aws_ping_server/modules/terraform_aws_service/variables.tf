variable "repository_url" {
  description = "ping server repository url"
  type        = string
  sensitive   = false
}

variable "target_group_arn" {
  description = "ping server target group arn"
  type = string
  sensitive = false
}

variable "vpc_id" {
  description = "vpc id"
  type = string
  sensitive = false
}

variable "autoscaling_group_vpc_zone_identifier" {
  description = "autoscaling group vpc zone identifier"
  type = list(string)
  sensitive = false
}

variable "loadbalancer_security_group_id" {
  description = "loadbalancer security group id"
  type = string
  sensitive = false
}
