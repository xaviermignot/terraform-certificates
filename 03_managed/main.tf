resource "azurerm_app_service_managed_certificate" "managed" {
  custom_hostname_binding_id = var.custom_domain_binding_id
}
