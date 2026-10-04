data "aws_iam_policy_document" "ci_policy" {

  # ECR authentication
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }

  # ECR repository operations
  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = [
      aws_ecr_repository.application.arn
    ]
  }

  # Read build artifacts
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "${aws_s3_bucket.artifacts.arn}/*"
    ]
  }

  # List bucket
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.artifacts.arn
    ]
  }

  # ECS deployment
  statement {
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:UpdateService"
    ]

    resources = [
      aws_ecs_service.application.id,
      aws_ecs_task_definition.application.arn
    ]
  }
}

resource "aws_iam_policy" "ci" {
  provider = aws.account_a

  name = "ci-least-privilege"

  policy = data.aws_iam_policy_document.ci_policy.json
}

resource "aws_iam_user_policy_attachment" "ci" {
  provider = aws.account_a

  user       = aws_iam_user.ci.name
  policy_arn = aws_iam_policy.ci.arn
}

