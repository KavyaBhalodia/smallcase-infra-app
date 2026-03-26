variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ebs_volume_size" {
  description = "Size of additional EBS volume in GB"
  type        = number
  default     = 1
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 8081
}

variable "project_name" {
  description = "Tag prefix for all resources"
  type        = string
  default     = "smallcase"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

