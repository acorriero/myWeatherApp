# Create the ECR repository
resource "aws_ecr_repository" "my_weather_app" {
  name = "my_weather_app"
  force_delete = true
}

# Build the Docker image
resource "docker_image" "my_weather_app" {
  name = "my_weather_app"
  
  build {
    path = "."
    dockerfile = "Dockerfile"
  }
}
