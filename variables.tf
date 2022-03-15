variable "location" {
  type        = string
  description = "The location to create the resources in"
}

variable "dns_zone_name" {
  type        = string
  description = "The name of the DNS Zone"
}

variable "dns_zone_rg_name" {
  type        = string
  description = "The name of the resource group containing the DNS Zone"
  default     = "rg-dns"
}
