locals {
  ami_filters = {
    "name"                = ["amzn2-ami-hvm-*-x86_64-gp2"]
    "virtualization-type" = ["hvm"]
    "root-device-type"    = ["ebs"]
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  dynamic "filter" {
    for_each = local.ami_filters
    content {
      name   = filter.key
      values = filter.value
    }
  }
}
