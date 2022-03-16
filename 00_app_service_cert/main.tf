resource "azurerm_app_service_certificate" "self_signed" {
  name                = "self-signed"
  resource_group_name = var.resource_group_name
  location            = var.location

  pfx_blob = var.pfx_value
  password = var.pfx_password
}

resource "azurerm_app_service_certificate_binding" "self_signed" {
  hostname_binding_id = var.custom_domain_binding_id
  certificate_id      = azurerm_app_service_certificate.self_signed.id
  ssl_state           = "SniEnabled"
}
