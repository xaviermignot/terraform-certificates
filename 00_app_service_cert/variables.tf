variable "resource_group_name" {
  type        = string
  description = "The name of the resource groups"
}

variable "location" {
  type        = string
  description = "The location to create the resources in"
}

variable "pfx_value" {
  type        = string
  description = "The value of the certificate in pfx format"
}

variable "pfx_password" {
  type        = string
  description = "The password of the pfx certificate"
  sensitive   = true
}

variable "custom_domain_binding_id" {
  type        = string
  description = "The identifier of the custom domain binding of the App Service"
}
