resource "aws_iam_user" "ses" {
  name = "${local.name}-ses-user"
}

resource "aws_iam_policy" "send_ses" {
  name   = "${local.name}-send-ses"
  policy = data.aws_iam_policy_document.send_ses.json
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
