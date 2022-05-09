provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

module "terraform_aws_images_repository" {
  source = "./modules/terraform_aws_images_repository"
}

module "terraform_aws_network" {
  source = "./modules/terraform_aws_network"
}

module "terraform_aws_loadbalancer" {
  source = "./modules/terraform_aws_loadbalancer"
  vpc_id = module.terraform_aws_network.main_vpc_id
  subnet_ids = module.terraform_aws_network.public_subnet_ids
}

module "terraform_aws_service" {
  source = "./modules/terraform_aws_service"
  repository_url = module.terraform_aws_images_repository.ping_server_repo_url
  target_group_arn = module.terraform_aws_loadbalancer.default_target_group_arn
  vpc_id = module.terraform_aws_network.main_vpc_id
  autoscaling_group_vpc_zone_identifier = module.terraform_aws_network.public_subnet_ids
}
