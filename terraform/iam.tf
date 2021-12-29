resource "aws_iam_user" "smtp" {
  name = "${local.name}-smtp-user"
}

resource "aws_iam_policy" "send_ses" {
  name   = "${local.name}-send-ses"
  policy = data.aws_iam_policy_document.send_ses.json
}

resource "aws_iam_user_policy_attachment" "send_ses" {
  user       = aws_iam_user.smtp.name
  policy_arn = aws_iam_policy.send_ses.arn
}

data "aws_iam_policy_document" "send_ses" {
  statement {
    effect    = "Allow"
    actions   = ["ses:SendRawEmail"]
    resources = [aws_ses_domain_identity.apilytics_io.arn]
  }
}
