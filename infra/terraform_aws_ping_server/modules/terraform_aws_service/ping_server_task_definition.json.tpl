[
  {
    "essential": true,
      "memory": 512,
      "name": "ping_server",
      "cpu": 1,
      "image": "${REPOSITORY_URL}:0.0.1",
      "environment": [],
      "portMappings": [
        { "containerPort": 4567, "protocol": "tcp" }
      ]
  }
]
