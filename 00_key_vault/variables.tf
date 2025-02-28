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
