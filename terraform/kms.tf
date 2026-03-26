resource "aws_kms_key" "ebs_key" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name    = "${var.project_name}-ebs-kms-key"
    Project = var.project_name
  }
}

resource "aws_kms_alias" "ebs_key_alias" {
  name          = "alias/${var.project_name}-ebs-key"
  target_key_id = aws_kms_key.ebs_key.key_id
}
