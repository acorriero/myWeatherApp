#!/bin/bash
apt-get update
apt-get install docker.io -y
systemctl start docker
systemctl enable docker

aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.my_weather_app.repository_url}

docker pull ${aws_ecr_repository.my_weather_app.repository_url}:latest

docker run -d --name my_weather_app -p 80:8501 ${aws_ecr_repository.my_weather_app.repository_url}:latest