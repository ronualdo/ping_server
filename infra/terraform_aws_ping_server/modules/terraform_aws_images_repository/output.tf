output "ping_server_repo_url" {
  description = "image repository url"
  value = aws_ecr_repository.ping_server.repository_url
}
