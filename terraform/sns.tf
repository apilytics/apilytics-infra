resource "aws_sns_topic" "ses_bounces" {
  name = "${local.name}-ses-bounces"
}

resource "aws_sns_topic_subscription" "ses_bounces" {
  endpoint  = local.alert_email
  protocol  = "email"
  topic_arn = aws_sns_topic.ses_bounces.arn
}
