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
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

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

  depends_on = [azurerm_role_assignment.kv_current_user]
}

resource "azurerm_app_service_certificate" "cert" {
  name                = "cert-key-vault"
  resource_group_name = var.resource_group_name
  location            = var.location

  key_vault_secret_id = azurerm_key_vault_certificate.cert.secret_id

  depends_on = [azurerm_role_assignment.kv_app_service]
}
