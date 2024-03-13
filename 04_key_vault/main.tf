locals {
  suffix = "tf-certs-demo-${var.suffix}"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = substr("kv-${local.suffix}", 0, 24)
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name                  = "standard"
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "kv_roles" {
  for_each             = toset(["Key Vault Certificates Officer", "Key Vault Crypto Officer"])
  scope                = azurerm_key_vault.kv.id
  role_definition_name = each.key
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_certificate" "cert" {
  name         = "cert-generated"
  key_vault_id = azurerm_key_vault.kv.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_type   = "RSA"
      key_size   = 2048
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=${var.common_name}"
      validity_in_months = 3

      subject_alternative_names {
        emails = [var.email]
      }
    }
  }
}

resource "azurerm_app_service_certificate" "cert" {
  name                = "cert-key-vault"
  resource_group_name = var.resource_group_name
  location            = var.location

  key_vault_secret_id = azurerm_key_vault_certificate.cert.secret_id
}
