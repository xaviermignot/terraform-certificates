output "pfx_value" {
  value = pkcs12_from_pem.self_signed_cert.result
}

output "pfx_password" {
  value = pkcs12_from_pem.self_signed_cert.password
}
