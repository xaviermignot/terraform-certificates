resource "azurerm_app_service_managed_certificate" "managed" {
  custom_hostname_binding_id = var.custom_domain_binding_id
}

resource "azurerm_app_service_certificate_binding" "name" {
  hostname_binding_id = var.custom_domain_binding_id
  certificate_id      = azurerm_app_service_managed_certificate.managed.id
  ssl_state           = "SniEnabled"
}
