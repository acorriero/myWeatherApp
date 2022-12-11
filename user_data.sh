#!/bin/bash
apt-get update -y
apt-get install docker.io -y
systemctl start docker
systemctl enable docker

cd /tmp
cat > Dockerfile << EOF
FROM nginx:1.23
EOF

docker build -t weather:0.1 .
docker run -d --name weather -p 80:80 --restart always weather:0.1