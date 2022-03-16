variable "common_name" {
  type        = string
  description = "The value of the CN field of the certificate"
}

variable "email" {
  type        = string
  description = "The email used for the registration of the certificate"
}

variable "dns" {
  type = object({
    zone_name    = string
    zone_rg_name = string
  })
  description = "The name and resource group of DNS zone"
}
