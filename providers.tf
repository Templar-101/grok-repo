# providers.tf
cat > providers.tf << 'EOF'
provider "aws" {
  region = "us-east-1"
}
EOF
