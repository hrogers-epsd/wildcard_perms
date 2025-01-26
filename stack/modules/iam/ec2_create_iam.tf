# Create an IAM user
resource "aws_iam_user" "ec2_user" {
  name = "ec2_start_user"
}

# Create an access key
resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.ec2_user.name
}

# Create a role to start EC2 instances
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

# Create a policy to start EC2 instances
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

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_start_role.name
  policy_arn = aws_iam_policy.ec2_start_policy.arn
}

# Output the access key
output "access_key_id" {
  value = aws_iam_access_key.user_key.id
}

# Output the secret key
output "secret_access_key" {
  value     = aws_iam_access_key.user_key.secret
  sensitive = true
}
