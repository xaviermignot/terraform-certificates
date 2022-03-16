resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "self_signed_cert" {
  key_algorithm   = tls_private_key.private_key.algorithm
  private_key_pem = tls_private_key.private_key.private_key_pem

  validity_period_hours = 48

  subject {
    common_name = var.common_name
  }

  allowed_uses = ["key_encipherment", "digital_signature", "server_auth"]
}

resource "random_password" "self_signed_cert" {
  length  = 24
  special = true
}

resource "pkcs12_from_pem" "self_signed_cert" {
  cert_pem        = tls_self_signed_cert.self_signed_cert.cert_pem
  private_key_pem = tls_private_key.private_key.private_key_pem
  password        = random_password.self_signed_cert.result
}

resource "azurerm_app_service_certificate" "self_signed_cert" {
  name                = "self-signed"
  resource_group_name = var.resource_group_name
  location            = var.location

  pfx_blob = pkcs12_from_pem.self_signed_cert.result
  password = pkcs12_from_pem.self_signed_cert.password
}
