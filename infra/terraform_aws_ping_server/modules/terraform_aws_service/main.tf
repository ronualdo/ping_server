# IAM
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}
#IAM

# AUTOSCALING GROUP

data "aws_ami" "default" {
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.202*-x86_64-ebs"]
  }

  most_recent = true
  owners      = ["amazon"]
}

resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix="ping-server"
  image_id = data.aws_ami.default.id
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups = [aws_security_group.ping_server.id]
  user_data = "#!/bin/bash\necho ECS_CLUSTER=ping-server-cluster >> /etc/ecs/ecs.config"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  name  = "ping-server"
  vpc_zone_identifier = var.autoscaling_group_vpc_zone_identifier
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity = 2
  min_size  = 1
  max_size  = 10
  health_check_grace_period = 300
  health_check_type = "EC2"
}
# AUTOSCALING GROUP

resource "aws_security_group" "ping_server" {
  name = "ping-server"
  vpc_id = var.vpc_id
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 4567
    to_port = 4567
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "ping_server_cluster" {
  name = "ping-server-cluster"
}

data "template_file" "ping_server_task_definition" {
  template = file("modules/terraform_aws_service/ping_server_task_definition.json.tpl")
  vars = {
    REPOSITORY_URL = replace(var.repository_url, "https://", "")
  }
}

resource "aws_ecs_task_definition" "ping_server_task_definition" {
  family                = "ping_server_task"
  container_definitions = data.template_file.ping_server_task_definition.rendered
}

resource "aws_ecs_service" "ping_server" {
  name            = "ping_server_service"
  cluster         = aws_ecs_cluster.ping_server_cluster.id
  task_definition = aws_ecs_task_definition.ping_server_task_definition.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = "ping_server"
    container_port = 4567
  }
}
