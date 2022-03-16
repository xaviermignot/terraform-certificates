output "pfx_value" {
  value = acme_certificate.cert.certificate_p12
}

output "pfx_password" {
  value = acme_certificate.cert.certificate_p12_password
}
