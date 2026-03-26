resource "null_resource" "docker_build_push" {
  # Rebuild and push whenever any of these app files change
  triggers = {
    app_py           = filemd5("${path.module}/../app/app.py")
    requirements_txt = filemd5("${path.module}/../app/requirements.txt")
    dockerfile       = filemd5("${path.module}/../app/Dockerfile")
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.app.repository_url}
      docker build -t ${aws_ecr_repository.app.repository_url}:latest ../app
      docker push ${aws_ecr_repository.app.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.app]
}
