terraform {
  required_providers {
    pkcs12 = {
      source  = "chilicat/pkcs12"
      version = "~> 0.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }
}

provider "acme" {
  # staging
  # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  # production
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
