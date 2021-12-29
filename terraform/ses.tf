resource "aws_ses_domain_identity" "apilytics_io" {
  domain = "apilytics.io"
}

resource "aws_ses_domain_dkim" "apilytics_io" {
  domain = aws_ses_domain_identity.apilytics_io.domain
}
