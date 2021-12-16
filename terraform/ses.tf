resource "aws_ses_domain_identity" "apilytics_io" {
  domain = "apilytics.io"
}

resource "aws_ses_domain_dkim" "apilytics_io" {
  domain = aws_ses_domain_identity.apilytics_io.domain
}

resource "aws_ses_configuration_set" "this" {
  name = "${local.name}-ses-config"
}

resource "aws_ses_event_destination" "this" {
  name                   = "${local.name}-ses-destination"
  configuration_set_name = aws_ses_configuration_set.this.name
  matching_types         = ["bounce", "complaint", "reject"]
  enabled                = true

  cloudwatch_destination {
    default_value  = "default"
    dimension_name = "dimension"
    value_source   = "emailHeader"
  }
}
