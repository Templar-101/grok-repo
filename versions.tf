# versions.tf
cat > versions.tf << 'EOF'
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "grok-repo-terraform-state-886036506684"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "grok-repo-terraform-locks"
    encrypt        = true
  }
}
EOF
