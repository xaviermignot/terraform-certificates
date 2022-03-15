variable "suffix" {
  type        = string
  description = "The suffix to use in resource names"
}

variable "location" {
  type        = string
  description = "The location to create the resources in"
}

variable "dns" {
  type = object({
    zone_name    = string
    zone_rg_name = string
  })
  description = "The name and resource group of DNS zone"
}
