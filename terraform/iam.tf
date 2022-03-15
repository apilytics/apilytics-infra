resource "aws_iam_user" "geoip_repo" {
  name = "${local.name}-geoip-repo-user"
}

resource "aws_iam_user" "ses" {
  name = "${local.name}-ses-user"
}

resource "aws_iam_policy" "send_ses" {
  name   = "${local.name}-send-ses"
  policy = data.aws_iam_policy_document.send_ses.json
}

resource "aws_iam_user_policy_attachment" "geoip_repo_ecr" {
  user       = aws_iam_user.geoip_repo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_user_policy_attachment" "geoip_repo_ecs" {
  user       = aws_iam_user.geoip_repo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_user_policy_attachment" "send_ses" {
  user       = aws_iam_user.ses.name
  policy_arn = aws_iam_policy.send_ses.arn
}

data "aws_iam_policy_document" "send_ses" {
  statement {
    effect    = "Allow"
    actions   = ["ses:SendRawEmail", "ses:SendEmail"]
    resources = [aws_ses_domain_identity.apilytics_io.arn]
  }
}
