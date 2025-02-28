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

variable "binding_cert" {
  type = string
  description = "The type of certificate to use for the binding"
  default = "self_signed"

  validation {
    condition = contains(["self_signed", "acme", "managed", "kv_self_signed", "kv_acme"], var.binding_cert)
    error_message = "The binding_cert variable must be one of self_signed, acme, managed, kv_self_signed or kv_acme."
  }  
}
