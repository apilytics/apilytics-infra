resource "aws_iam_policy" "rds_secret" {
  name   = "${var.name}-rds-secret"
  policy = data.aws_iam_policy_document.rds_secret.json
}

resource "aws_iam_role" "rds_secret" {
  name               = "${var.name}-rds-secret"
  assume_role_policy = data.aws_iam_policy_document.assume_rds_secret.json
}

resource "aws_iam_role_policy_attachment" "rds_secret" {
  policy_arn = aws_iam_policy.rds_secret.arn
  role       = aws_iam_role.rds_secret.arn
}

data "aws_region" "current" {}

data "aws_iam_policy_document" "rds_secret" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.rds.arn]
  }

  statement {
    actions   = ["kms:Decrypt"]
    resources = ["alias/aws/secretsmanager"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["secretsmanager.${data.aws_region.current.name}.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_rds_secret" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}
