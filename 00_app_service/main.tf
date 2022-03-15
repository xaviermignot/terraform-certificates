locals {
  suffix = "tf-certs-demo-${var.suffix}"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.suffix}"
  location = var.location
}

resource "azurerm_app_service_plan" "plan" {
  name                = "plan-${local.suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier     = "Basic"
    size     = "B1"
    capacity = 1
  }

  kind     = "Linux"
  reserved = true
}

resource "azurerm_app_service" "app" {
  name                = "web-${local.suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
    linux_fx_version         = "DOTNETCORE|6.0"
    dotnet_framework_version = "v6.0"
  }
}

# TXT record for verifying domain ownership
resource "azurerm_dns_txt_record" "app" {
  name                = "asuid.${azurerm_app_service.app.name}"
  zone_name           = var.dns.zone_name
  resource_group_name = var.dns.zone_rg_name
  ttl                 = 300

  record {
    value = azurerm_app_service.app.custom_domain_verification_id
  }
}

# CNAME record
resource "azurerm_dns_cname_record" "app" {
  name                = "tf-certs-demo"
  zone_name           = var.dns.zone_name
  resource_group_name = var.dns.zone_rg_name
  ttl                 = 300

  record = azurerm_app_service.app.default_site_hostname
}

# Bind app service to custom domain
resource "azurerm_app_service_custom_hostname_binding" "app" {
  hostname            = "tf-certs-demo.${var.dns.zone_name}"
  app_service_name    = azurerm_app_service.app.name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [azurerm_dns_txt_record.app]
}
