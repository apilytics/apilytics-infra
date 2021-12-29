resource "aws_ses_domain_identity" "apilytics_io" {
  domain = "apilytics.io"
}

resource "aws_ses_domain_dkim" "apilytics_io" {
  domain = aws_ses_domain_identity.apilytics_io.domain
}

resource "aws_ses_identity_notification_topic" "apilytics_io" {
  for_each = toset(["Bounce", "Complaint"])

  topic_arn                = aws_sns_topic.ses_bounces.arn
  notification_type        = each.value
  identity                 = aws_ses_domain_identity.apilytics_io.domain
  include_original_headers = true
}
