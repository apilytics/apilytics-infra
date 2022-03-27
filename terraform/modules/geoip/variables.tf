variable "name" {
  description = "Name that's used for all the resources as an identifier."
  type        = string
}

variable "domain" {
  description = "The domain where the service should be accessible from."
  type        = string
}

variable "api_key" {
  description = "API key that's used to access the service."
  type        = string
  sensitive   = true
}

variable "vpc_cidr_block" {
  type = string
}
