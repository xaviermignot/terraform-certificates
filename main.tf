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
  source = "./01_self_signed"

  resource_group_name = module.app_service.resource_group_name
  location            = var.location
  common_name         = module.app_service.custom_hostname
}

# This module gets a certificate from Let's Encrypt and creates an App Service certificate from it
module "acme" {
  source = "./02_acme"

  resource_group_name = module.app_service.resource_group_name
  location            = var.location
  common_name         = module.app_service.custom_hostname
  email               = "contact@${var.dns_zone_name}"

  dns = {
    zone_name    = var.dns_zone_name
    zone_rg_name = var.dns_zone_rg_name
  }
}

# This module creates an App Service managed certificate
module "managed" {
  source = "./03_managed"

  custom_domain_binding_id = module.app_service.custom_domain_binding_id
}

# The binding between the App Service custom domain and the certificate is done here.
# You can choose which certificate is used and see the result after applying the changes
resource "azurerm_app_service_certificate_binding" "cert_binding" {
  certificate_id      = module.managed.certificate_id
  hostname_binding_id = module.app_service.custom_domain_binding_id
  ssl_state           = "SniEnabled"
}
