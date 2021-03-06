output "default_hostname" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "custom_hostname" {
  value = azurerm_app_service_custom_hostname_binding.app.hostname
}

output "custom_domain_binding_id" {
  value = azurerm_app_service_custom_hostname_binding.app.id
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
