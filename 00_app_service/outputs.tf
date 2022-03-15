output "default_hostname" {
  value = azurerm_app_service.app.default_site_hostname
}

output "custom_hostname" {
  value = azurerm_app_service_custom_hostname_binding.app.hostname
}

output "custom_domain_binding_id" {
  value = azurerm_app_service_custom_hostname_binding.app.id
}
