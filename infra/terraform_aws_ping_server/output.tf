output "pingserver_dns_name" {
  description = "ping server dns name"
  value = module.terraform_aws_loadbalancer.dns_name
}

output "image_repository_url" {
  description = "image repository url"
  value = module.terraform_aws_images_repository.ping_server_repo_url
}
