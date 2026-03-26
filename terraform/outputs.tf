output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app_server.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "app_url" {
  description = "URL to reach the application"
  value       = "http://${aws_instance.app_server.public_ip}:${var.app_port}/api/v1"
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for EBS encryption"
  value       = aws_kms_key.ebs_key.arn
}

output "ebs_volume_id" {
  description = "ID of the attached EBS data volume"
  value       = aws_ebs_volume.app_data.id
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}
