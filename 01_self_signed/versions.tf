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
  }
}
