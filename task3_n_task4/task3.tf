// Create IAM users
resource "aws_iam_user" "engine" {
  provider = aws.account_a
  name     = "engine"
}

resource "aws_iam_user" "ci" {
  provider = aws.account_a
  name     = "ci"
}

resource "aws_iam_user" "console_users" {
  provider = aws.account_a
  for_each = toset(var.console_users)

  name = each.value
}

//Create Group1 and add users to it
resource "aws_iam_group" "group1" {
  provider = aws.account_a
  name     = "group1"
}

resource "aws_iam_user_group_membership" "group1" {
  provider = aws.account_a

  user = [
    "${aws_iam_user.engine.name}",
    "${aws_iam_user.ci.name}"
  ]

  groups = [
    aws_iam_group.group1.name
  ]
}

// Create Group2 and add users to it
resource "aws_iam_group" "group2" {
  provider = aws.account_a
  name     = "group2"
}

resource "aws_iam_user_group_membership" "group2" {
  provider = aws.account_a

  user = [
    for user in aws_iam_user.console_users : user.name
  ]

  groups = [
    aws_iam_group.group2.name
  ]
}

resource "aws_iam_user_login_profile" "console_users" {
  provider = aws.account_a

  for_each = aws_iam_user.console_users

  user                    = each.value.name
  password_reset_required = true
}


// Create IAM policies and RoleA
data "aws_iam_policy_document" "roleA_policy" {
  statement {
    effect = "Allow"

    actions = [
      "*"
    ]

    resources = [
      "*"
    ]

    # IAM is intentionally excluded.
    not_actions = [
      "iam:*"
    ]
  }
}

data "aws_iam_policy_document" "roleA_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"

      identifiers = [
        for user in aws_iam_user.console_users :
        user.arn
      ]
    }
  }
}

resource "aws_iam_policy" "roleA_policy" {
  provider = aws.account_a

  name = "roleA-admin-except-iam"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect    = "Allow"
        NotAction = "iam:*"
        Resource  = "*"
      }
    ]
  })
}

resource "aws_iam_role" "roleA" {
  provider = aws.account_a

  name = "roleA"

  assume_role_policy = data.aws_iam_policy_document.roleA_trust.json
}

resource "aws_iam_role_policy_attachment" "roleA" {
  provider = aws.account_a

  role       = aws_iam_role.roleA.name
  policy_arn = aws_iam_policy.roleA_policy.arn
}

// RoleA ends here


// Create RoleB 
resource "aws_iam_policy" "roleB_policy" {
  provider = aws.account_a

  name = "roleB-assume-roleC"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "sts:AssumeRole"
        ]

        Resource = "arn:aws:iam::480545061213:role/roleC"
      }
    ]
  })
}

data "aws_iam_policy_document" "roleB_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_iam_user.engine.arn
      ]
    }
  }
}

resource "aws_iam_role" "roleB" {
  provider = aws.account_a

  name = "roleB"

  assume_role_policy = data.aws_iam_policy_document.roleB_trust.json
}

resource "aws_iam_role_policy_attachment" "roleB" {
  provider = aws.account_a

  role       = aws_iam_role.roleB.name
  policy_arn = aws_iam_policy.roleB_policy.arn
}

// RoleB ends here

//Account B reources
resource "aws_s3_bucket" "artifacts" {
  provider = aws.account_b

  bucket = var.arrise_artifact_bucket
}

data "aws_iam_policy_document" "roleC_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::480545061213:role/roleB"
      ]
    }
  }
}

resource "aws_iam_role" "roleC" {
  provider = aws.account_b

  name = "roleC"

  assume_role_policy = data.aws_iam_policy_document.roleC_trust.json
}

resource "aws_iam_policy" "roleC_s3" {
  provider = aws.account_b

  name = "roleC-s3-access"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:*"
        ]

        Resource = [
          aws_s3_bucket.artifacts.arn,
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "roleC_s3" {
  provider = aws.account_b

  role       = aws_iam_role.roleC.name
  policy_arn = aws_iam_policy.roleC_s3.arn
}
