data "azurerm_client_config" "current" {}

data "azuread_service_principal" "app_service" {
  client_id = "abfa0a7c-a6b6-4736-8310-5855508787cd"
}

locals {
  role_assigments = {
    current_user = toset(["Key Vault Certificates Officer"])
    app_service  = toset(["Key Vault Certificate User", "Key Vault Secrets User"])
  }
}

resource "azurerm_role_assignment" "kv_current_user" {
  for_each             = local.role_assigments.current_user
  scope                = azurerm_key_vault.kv.id
  role_definition_name = each.key
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kv_app_service" {
  for_each             = local.role_assigments.app_service
  scope                = azurerm_key_vault.kv.id
  role_definition_name = each.key
  principal_id         = data.azuread_service_principal.app_service.object_id
}
