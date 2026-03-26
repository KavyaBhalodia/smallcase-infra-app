#!/bin/bash
set -e

# Update packages and install Docker
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Authenticate to ECR and pull the app image
aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${ecr_repo_url}
docker pull ${ecr_repo_url}:1.0
docker run -d \
  --name smallcase-app \
  -p ${app_port}:${app_port} \
  --restart unless-stopped \
  ${ecr_repo_url}:1.0
