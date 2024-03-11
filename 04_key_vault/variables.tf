variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "suffix" {
  type        = string
  description = "The suffix to use in resource names"
}

variable "location" {
  type        = string
  description = "The location to create the resources in"
}

variable "common_name" {
  type        = string
  description = "The value of the CN field of the certificate"
}

variable "email" {
  type        = string
  description = "The email used for the registration of the certificate"
}
