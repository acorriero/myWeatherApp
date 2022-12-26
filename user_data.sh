#!/bin/bash
apt-get update -y
apt-get install docker.io awscli -y
systemctl start docker
systemctl enable docker

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 503680398283.dkr.ecr.us-east-1.amazonaws.com

docker pull 503680398283.dkr.ecr.us-east-1.amazonaws.com/my_weather_app:latest

docker run -d --name my_weather_app -p 80:8501 503680398283.dkr.ecr.us-east-1.amazonaws.com/my_weather_app