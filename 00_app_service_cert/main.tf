resource "azurerm_app_service_certificate" "cert" {
  name                = "self-signed"
  resource_group_name = var.resource_group_name
  location            = var.location

  pfx_blob = var.pfx_value
  password = var.pfx_password
}

resource "azurerm_app_service_certificate_binding" "cert_binding" {
  hostname_binding_id = var.custom_domain_binding_id
  certificate_id      = azurerm_app_service_certificate.cert.id
  ssl_state           = "SniEnabled"
}
