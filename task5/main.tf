data "aws_iam_policy_document" "roleC_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      //identifiers = ["arn:aws:iam::000000000000:user/roleB"] // Incorrect Line 
      /*
       Error: creating IAM Role (roleC): operation error IAM: CreateRole, https response error StatusCode: 400, RequestID: cb63eff1-924b-4035-9646-e5d2dd4323c8, 
       MalformedPolicyDocument: Invalid principal in policy: "AWS":"arn:aws:iam::000000000000:user/roleB"
       with aws_iam_role.roleC,
       on main.tf line 13, in resource "aws_iam_role" "roleC":
       13: resource "aws_iam_role" "roleC" {
      */
      identifiers = ["arn:aws:iam::480545061213:role/roleB"] // Corrected Line with role instead user. RoleB should exist.
    }
  }
}

resource "aws_iam_role" "roleC" {
  name               = "roleC"
  assume_role_policy = data.aws_iam_policy_document.roleC_trust.json
}

resource "aws_iam_role_policy" "roleC_s3" {
  name = "roleC-s3-access"
  role = aws_iam_role.roleC.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:*"
      Resource = "*"
    }]
  })
}
