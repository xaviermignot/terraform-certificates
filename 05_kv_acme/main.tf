locals {
  suffix = "tf-certs-demo-${var.suffix}"
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_certificate" "cert" {
  name         = "cert-generated"
  key_vault_id = data.azurerm_key_vault.kv.id

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
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
    }
  }

  provisioner "local-exec" {
    command = <<EOT
csr=$(az keyvault certificate pending show -n ${self.name} --vault-name "$KV_NAME" --query csr -o tsv)
echo '-----BEGIN CERTIFICATE REQUEST-----' && echo "$csr" && echo '-----END CERTIFICATE REQUEST-----' > ./cert.csr
acme.sh --signcsr --csr ./cert.csr --dns dns_azure
    EOT

    environment = {
      KV_NAME = data.azurerm_key_vault.kv.name
    }
  }
}

resource "azurerm_app_service_certificate" "cert" {
  name                = "cert-key-vault"
  resource_group_name = var.resource_group_name
  location            = var.location

  key_vault_secret_id = azurerm_key_vault_certificate.cert.secret_id
}
