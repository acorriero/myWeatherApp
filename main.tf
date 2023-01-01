# Generate a key pair
resource "aws_key_pair" "weather_app_key" {
  key_name = "weather_app_key"
  public_key = file("/var/lib/jenkins/.ssh/weather_app_rsa.pub")
}

# Create VPC
resource "aws_vpc" "weather_app_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "weather_app_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "weather_app_gw" {
  vpc_id = aws_vpc.weather_app_vpc.id
}

# Create Custom Route Table
resource "aws_route_table" "weather_app_rtb" {
  vpc_id = aws_vpc.weather_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.weather_app_gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.weather_app_gw.id
  }

  tags = {
    Name = "weather_app_rtb"
  }
}

# Create Subnet
resource "aws_subnet" "weather_app_subnet" {
  vpc_id     = aws_vpc.weather_app_vpc.id
  cidr_block = var.subnet_prefix
  availability_zone = "us-east-1a"
  tags = {
    Name = "weather_app_subnet"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "route-table-a" {
  subnet_id      = aws_subnet.weather_app_subnet.id
  route_table_id = aws_route_table.weather_app_rtb.id
}

# Create Security Group
resource "aws_security_group" "weather_app_sg" {
  name        = "weather_app_sg"
  description = "Allow 22, 80 and 443"
  vpc_id      = aws_vpc.weather_app_vpc.id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# Create a network interface with an ip in the subnet that was created above.
resource "aws_network_interface" "weather_app_nic" {
  subnet_id       = aws_subnet.weather_app_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.weather_app_sg.id]
}

# Assign an elastic IP to the network interface created above
resource "aws_eip" "weather_app_eip" {
  vpc                       = true
  network_interface         = aws_network_interface.weather_app_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.weather_app_gw]
}

# Create application server
resource "aws_instance" "web-server" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "weather_app_key"
  iam_instance_profile = aws_iam_instance_profile.web_app_profile.name

  network_interface {
    network_interface_id = aws_network_interface.weather_app_nic.id
    device_index = 0
  }

  # Push docker image to ECR repository
  provisioner "local-exec" {
    inline = [
      "docker tag my_weather_app:latest ${aws_ecr_repository.my_weather_app.repository_url}:latest",
      "aws ecr get-login-password --region ${var.region} \
        | docker login --username AWS --password-stdin ${aws_ecr_repository.my_weather_app.repository_url}"
      "docker push ${aws_ecr_repository.my_weather_app.repository_url}:latest"
    ]
  }

  provisioner "file" {
    content =<<-EOF
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install docker.io awscli -y
      sudo systemctl start docker
      sudo systemctl enable docker
      sudo aws ecr get-login-password --region "${var.region}" | docker login --username AWS --password-stdin "${var.ecr_rep}"
      sudo docker pull "${var.ecr_rep}:latest"
      sudo ocker run -d --name my_weather_app -p 80:8501 "${var.ecr_rep}:latest"
    EOF
    destination = "/tmp/setup_script.sh"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key =  file("/var/lib/jenkins/.ssh/weather_app_rsa")
      host     = self.public_ip
    }
    
    inline = [
    "/tmp/setup_script.sh"
    ]
  }

  # user_data = data.template_file.user_data.rendered

  tags = {
    Name = "my_weather_app"
  }
  depends_on = [
    aws_ecr_repository.my_weather_app,
    docker_image.my_weather_app
    ]
}

# General information to output
output "server_public_ip" {
  value = aws_eip.weather_app_eip.public_ip
}

output "server_private_ip" {
  value = aws_instance.web-server.private_ip
}

output "server_id" {
  value = aws_instance.web-server.id
}
