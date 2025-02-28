locals {
  suffix = "tf-certs-demo-${var.suffix}"
}

resource "azurerm_key_vault" "kv" {
  name                = substr("kv-${local.suffix}", 0, 24)
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name                  = "standard"
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
}
