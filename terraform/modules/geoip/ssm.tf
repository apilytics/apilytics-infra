resource "aws_ssm_parameter" "api_key" {
  name  = "${upper(replace(var.name, "-", "_"))}_API_KEY"
  type  = "SecureString"
  value = var.api_key
}
