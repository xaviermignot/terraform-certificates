terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"
    }
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
