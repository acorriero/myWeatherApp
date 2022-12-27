data "template_file" "user_data" {
  template = file("user_data.sh")

  vars = {
    region = var.region
    ecr_rep = aws_ecr_repository.my_weather_app.repository_url
  }
}