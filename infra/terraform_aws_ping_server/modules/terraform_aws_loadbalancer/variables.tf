variable "vpc_id" {
  description = "loadbalancer vpc id"
  type = string
  sensitive = false
}

variable "subnet_ids" {
  description = "loadbalancer subnet ids"
  type = list(string)
  sensitive = false
}
