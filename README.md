# smallcase-infra-app

## Approach

### Dynamic AMI
- Used `data "aws_ami"` with `most_recent = true` and a dynamic filter block
- Resolves the correct Amazon Linux 2 AMI per region automatically, no hardcoded AMI IDs

### KMS Encrypted EBS
- Customer-managed KMS key with auto-rotation enabled
- Both root volume and attached data volume (1GB, `/dev/xvdf`) are encrypted using the same key

### Networking
- Dedicated VPC with public subnet, internet gateway, and route table
- Security group allows inbound on port 22 (SSH) and 8081 (app) only

### Docker Build & Push
- `null_resource` with `local-exec` authenticates to ECR, builds the image, and pushes to AWS ECR
- Triggers on file hash changes to `app.py`, `requirements.txt`, and `Dockerfile`
- EC2 has `depends_on` on this resource so the image is always pushed before the instance launches

### Deployment
- EC2 is assigned an IAM instance profile with ECR pull permissions
- `user_data.sh` installs Docker, authenticates to ECR, pulls the image, and starts the container on first boot
- The `docker run` command is included in `user_data.sh` purely so the full stack comes up automatically on `terraform apply`, it runs once at instance launch and should not be used as a redeployment mechanism
- A single `terraform apply` brings up the full stack end to end

### Redeployment
- Not handled in the current setup as I assumed it is out of scope for this assignment
- Can be extended by adding a `remote-exec` null_resource to SSH into the instance and run `docker pull` + `docker restart` on every apply, or by integrating a CI/CD pipeline (e.g. GitHub Actions) to automate the full build and deploy cycle on every push

## Prerequisites

- Terraform, AWS CLI configured, Docker
- Generate SSH key: `ssh-keygen -t rsa -b 4096 -f ~/.ssh/smallcase-key -N ""`

## Deploy

Ensure AWS credentials are configured via `aws configure` or environment variables before running.

```bash
cd terraform
terraform init && terraform apply

# Test (wait ~2 min after apply)
curl http://$(public_ip):8081/api/v1

# Tear down
terraform destroy
```

---

Note: I did this setup keeping in mind the assignment instructions. This is not a production grade version, to make it production grade would have done certain things differently.
