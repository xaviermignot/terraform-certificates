terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  alias      = "staging"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
