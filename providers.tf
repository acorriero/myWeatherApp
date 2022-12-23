terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.24.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

provider "docker" {
  # Configuration options
}

provider "aws" {
  region = var.region
}