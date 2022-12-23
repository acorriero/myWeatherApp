variable "subnet_prefix" {
  type        = string
  default     = "10.0.1.0/24"
  description = "cidr block for the subnet"
}

variable "region" {
  type = string
  default = "us-east-1"
}