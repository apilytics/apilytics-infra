variable "geoip_prod_api_key" {
  description = "API key that's used to access the GeoIP production service."
  type        = string
  sensitive   = true
}

variable "internal_api_key" {
  description = "API key that's used to call internal email APIs."
  type        = string
  sensitive   = true
}
