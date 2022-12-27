#!/bin/bash
apt-get update -y
apt-get install docker.io unzip -y
systemctl start docker
systemctl enable docker

cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 503680398283.dkr.ecr.us-east-1.amazonaws.com

docker pull 503680398283.dkr.ecr.us-east-1.amazonaws.com/my_weather_app:latest

docker run -d --name my_weather_app -p 80:8501 503680398283.dkr.ecr.us-east-1.amazonaws.com/my_weather_app