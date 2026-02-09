# main.tf (EC2 instance with SSM)
cat > main.tf << 'EOF'
data "aws_subnet" "selected" {
  id = "subnet-02c54e0679129396f"
}

data "aws_security_group" "selected" {
  id = "sg-08766eabe9c8d620e"
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_instance" "app" {
  ami                    = "ami-0532be01f26a3de55"
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.selected.id
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  associate_public_ip_address = true

  tags = {
    Name        = "grok-demo-instance"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Repo        = "Templar-101/grok-repo"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from Grok + Terraform + GitHub Actions" > /home/ec2-user/welcome.txt
    EOF
}
EOF
