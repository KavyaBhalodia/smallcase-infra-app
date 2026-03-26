resource "aws_key_pair" "app_key" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)

  tags = {
    Name    = "${var.project_name}-key"
    Project = var.project_name
  }
}

resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.app_key.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  depends_on = [null_resource.docker_build_push]

  user_data = templatefile("${path.module}/user_data.sh", {
    aws_region   = var.aws_region
    ecr_repo_url = aws_ecr_repository.app.repository_url
    app_port     = var.app_port
  })

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
    kms_key_id  = aws_kms_key.ebs_key.arn
  }

  tags = {
    Name    = "${var.project_name}-app-server"
    Project = var.project_name
  }
}

resource "aws_ebs_volume" "app_data" {
  availability_zone = aws_instance.app_server.availability_zone
  size              = var.ebs_volume_size
  type              = "gp3"
  encrypted         = true
  kms_key_id        = aws_kms_key.ebs_key.arn

  tags = {
    Name    = "${var.project_name}-data-volume"
    Project = var.project_name
  }
}

resource "aws_volume_attachment" "app_data_att" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.app_data.id
  instance_id = aws_instance.app_server.id
}
