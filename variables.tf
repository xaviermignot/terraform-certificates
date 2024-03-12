variable "location" {
  type        = string
  description = "The location to create the resources in"
  default     = "francecentral"
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

variable "module_to_use" {
  type        = string
  description = "The name of the module to use"
  default     = "managed"
  validation {
    condition     = contains(["self_signed", "acme", "managed", "key_vault"], var.module_to_use)
    error_message = "Variable module_to_use must be either 'self_signed', 'acme', 'managed' or 'key_vault'."
  }
}
