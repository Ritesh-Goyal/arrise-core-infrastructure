# setup aws provider for dev account
provider "aws" {
  alias   = "dev"
  region  = var.aws_region
  profile = "dev"
}

# in dev account create iam policy, which will grants admin rights
resource "aws_iam_policy" "external_admin_policy" {
  provider = aws.dev
  name     = "ExternalAdminPolicy"
  path     = "/"
  policy   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

# in dev account create a role which can be assumed by main account
resource "aws_iam_role" "external_admin_role" {
  provider           = aws.dev
  name               = "ExternalAdminRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.main_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# attach policy to role
resource "aws_iam_policy_attachment" "external_admin_policy_attachment_to_external_admin_role" {
  provider   = aws.dev
  name       = "external_admin_policy_attachment"
  roles      = ["${aws_iam_role.external_admin_role.name}"]
  policy_arn = aws_iam_policy.external_admin_policy.arn
}



# in dev account create iam policy, which will grants admin rights
resource "aws_iam_policy" "external_s3_policy" {
  provider = aws.dev
  name     = "ExternalS3Policy"
  path     = "/"
  policy   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}

# in dev account create a role which can be assumed by main account
resource "aws_iam_role" "external_s3_role" {
  provider           = aws.dev
  name               = "ExternalS3Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.main_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# attach policy to role
resource "aws_iam_policy_attachment" "external_s3_policy_attachment_to_external_s3_role" {
  provider   = aws.dev
  name       = "external_s3_policy_attachment"
  roles      = ["${aws_iam_role.external_s3_role.name}"]
  policy_arn = aws_iam_policy.external_s3_policy.arn
}