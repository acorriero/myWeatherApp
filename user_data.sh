#!/bin/bash
apt-get update
apt-get install docker.io awscli -y
systemctl start docker
systemctl enable docker

aws ecr get-login-password --region "${var.region}" | docker login --username AWS --password-stdin "${var.ecr_rep}"

docker pull "${var.ecr_rep}:latest"

docker run -d --name my_weather_app -p 80:8501 "${var.ecr_rep}:latest"