resource "random_pet" "suffix" {}

module "app_service" {
  source = "./00_app_service"

  suffix   = random_pet.suffix.id
  location = var.location

  dns = {
    zone_name    = var.dns_zone_name
    zone_rg_name = var.dns_zone_rg_name
  }
}

module "self_signed" {
  source = "./01_self_signed"

  resource_group_name = module.app_service.resource_group_name
  location            = var.location
  common_name         = module.app_service.custom_hostname
}

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

module "managed" {
  source = "./03_managed"

  custom_domain_binding_id = module.app_service.custom_domain_binding_id
}

resource "azurerm_app_service_certificate_binding" "cert_binding" {
  hostname_binding_id = module.app_service.custom_domain_binding_id
  certificate_id      = module.self_signed.certificate_id
  ssl_state           = "SniEnabled"
}
