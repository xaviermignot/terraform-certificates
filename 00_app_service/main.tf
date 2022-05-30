locals {
  suffix = "tf-certs-demo-${var.suffix}"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.suffix}"
  location = var.location
}

resource "azurerm_service_plan" "plan" {
  name                = "plan-${local.suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type  = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "web-${local.suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  service_plan_id = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
}

# TXT record for verifying domain ownership
resource "azurerm_dns_txt_record" "app" {
  name                = "asuid.${azurerm_linux_web_app.app.name}"
  zone_name           = var.dns.zone_name
  resource_group_name = var.dns.zone_rg_name
  ttl                 = 300

  record {
    value = azurerm_linux_web_app.app.custom_domain_verification_id
  }
}

# CNAME record
resource "azurerm_dns_cname_record" "app" {
  name                = "tf-certs-demo"
  zone_name           = var.dns.zone_name
  resource_group_name = var.dns.zone_rg_name
  ttl                 = 300

  record = azurerm_linux_web_app.app.default_hostname
}

# Bind app service to custom domain
resource "azurerm_app_service_custom_hostname_binding" "app" {
  hostname            = "tf-certs-demo.${var.dns.zone_name}"
  app_service_name    = azurerm_linux_web_app.app.name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [azurerm_dns_txt_record.app]
}
