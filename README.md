# my_weather_app
Complete CI/CD pipeline that puts a Docker/Python created weather app on an ec2 instance

- Install Jenkins, Docker, aws-cli and Terraform on a host
- Jenkins:
  - Install AWS Credentials Plugin
  - Set up git ssh credentials with ID github-loign
  - Set up AWS credentials with mylab-aws
  - Create key pair as jenkins user: /var/lib/jenkins/.ssh/weather_app_rsa
  - Global Security: Git Host Key Verification Configuration (Accept first connection)
- Add yourself and jenkins to docker group: sudo usermod -aG docker $USER && sudo usermod -aG docker jenkins
