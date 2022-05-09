[
  {
    "essential": true,
      "memory": 512,
      "name": "ping_server",
      "cpu": 1,
      "image": "${REPOSITORY_URL}:latest",
      "environment": [],
      "portMappings": [
        { "containerPort": 4567, "protocol": "tcp" }
      ]
  }
]
