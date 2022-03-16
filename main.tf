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

  common_name = module.app_service.custom_hostname
}

module "acme" {
  source = "./02_acme"

  common_name = module.app_service.custom_hostname
  email       = "contact@${var.dns_zone_name}"

  dns = {
    zone_name    = var.dns_zone_name
    zone_rg_name = var.dns_zone_rg_name
  }
}

module "app_service_cert" {
  source = "./00_app_service_cert"

  resource_group_name = module.app_service.resource_group_name
  location            = var.location
  pfx_value           = module.acme.pfx_value
  pfx_password        = module.acme.pfx_password
  # pfx_value                = module.self_signed.pfx_value
  # pfx_password             = module.self_signed.pfx_password
  custom_domain_binding_id = module.app_service.custom_domain_binding_id
}
