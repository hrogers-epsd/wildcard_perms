provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "ec2_user" {
  name = "ec2_start_user"
}

resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.ec2_user.name
}

resource "aws_iam_role" "ec2_start_role" {
  name = "ec2_start_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = aws_iam_user.ec2_user.arn
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_start_policy" {
  name        = "ec2_start_policy"
  description = "Allows starting EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ec2:StartInstances",
        #Action   = "*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_start_role.name
  policy_arn = aws_iam_policy.ec2_start_policy.arn
}

output "access_key_id" {
  value = aws_iam_access_key.user_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.user_key.secret
  sensitive = true
}
