resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email
}

resource "random_password" "cert" {
  length  = 24
  special = true
}

resource "acme_certificate" "cert" {
  account_key_pem          = acme_registration.reg.account_key_pem
  common_name              = var.common_name
  certificate_p12_password = random_password.cert.result

  dns_challenge {
    provider = "azure"

    config = {
      AZURE_RESOURCE_GROUP = var.dns.zone_rg_name
      AZURE_ZONE_NAME      = var.dns.zone_name
      AZURE_TTL            = 300
    }
  }
}

resource "azurerm_app_service_certificate" "cert" {
  name                = "acme"
  resource_group_name = var.resource_group_name
  location            = var.location

  pfx_blob = acme_certificate.cert.certificate_p12
  password = acme_certificate.cert.certificate_p12_password
}