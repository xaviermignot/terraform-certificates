# Generates a "pet name" in 2 words that is used in resource names to make them unique
resource "random_pet" "suffix" {}

# This module creates a resource group, an App Service, and binds it to a custom domain (without securing the binding)
module "app_service" {
  source = "./00_app_service"

  suffix   = random_pet.suffix.id
  location = var.location

  dns = {
    zone_name    = var.dns_zone_name
    zone_rg_name = var.dns_zone_rg_name
  }
}

# This module generates a self-signed certificate and creates an App Service certificate from it
module "self_signed" {
  count = var.module_to_use == "self_signed" ? 1 : 0

  source = "./01_self_signed"

  resource_group_name = module.app_service.resource_group_name
  location            = var.location
  common_name         = module.app_service.custom_hostname
}

# This module gets a certificate from Let's Encrypt and creates an App Service certificate from it
module "acme" {
  count = var.module_to_use == "acme" ? 1 : 0

  source = "./02_acme"

  resource_group_name = module.app_service.resource_group_name
  location            = var.location
  common_name         = module.app_service.custom_hostname
  email               = "contact@${var.dns_zone_name}"

  dns = {
    zone_name    = var.dns_zone_name
    zone_rg_name = var.dns_zone_rg_name
  }

  providers = {
    acme = acme
    # acme = acme.staging
  }
}

# This module creates an App Service managed certificate
module "managed" {
  count = var.module_to_use == "managed" ? 1 : 0

  source = "./03_managed"

  custom_domain_binding_id = module.app_service.custom_domain_binding_id
}

module "key_vault" {
  count = var.module_to_use == "key_vault" ? 1 : 0

  source = "./04_key_vault"

  resource_group_name = module.app_service.resource_group_name
  location            = var.location
  suffix              = random_pet.suffix.id
  common_name         = module.app_service.custom_hostname
  email               = "contact@${var.dns_zone_name}"
}

module "key_vault_acme" {
  count = var.module_to_use == "key_vault_acme" ? 1 : 0

  source = "./05_key_vault_acme"

  resource_group_name = module.app_service.resource_group_name
  location            = var.location
  suffix              = random_pet.suffix.id
  common_name         = module.app_service.custom_hostname
  email               = "contact@${var.dns_zone_name}"
}

locals {
  certificate_id = {
    self_signed    = var.module_to_use == "self_signed" ? module.self_signed[0].certificate_id : ""
    acme           = var.module_to_use == "acme" ? module.acme[0].certificate_id : ""
    managed        = var.module_to_use == "acme" ? module.acme[0].certificate_id : ""
    key_vault      = var.module_to_use == "key_vault" ? module.key_vault[0].certificate_id : ""
    key_vault_acme = var.module_to_use == "key_vault_acme" ? module.key_vault_acme[0].certificate_id : ""
  }[var.module_to_use]
}

# The binding between the App Service custom domain and the certificate is done here.
# You can choose which certificate is used and see the result after applying the changes
resource "azurerm_app_service_certificate_binding" "cert_binding" {
  certificate_id      = local.certificate_id
  hostname_binding_id = module.app_service.custom_domain_binding_id
  ssl_state           = "SniEnabled"
}
