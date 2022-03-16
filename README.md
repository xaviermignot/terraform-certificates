# Certificate generation with Terraform for Azure App Service

This repository contains sample code to generate TLS certificates using Terraform.  
It uses an Azure App Service as an example of a website to secure.

The certificates are generated in 3 ways:
1. By creating a self-signed certificate
2. By requesting a certificate from Let's Encrypt
3. By creating an Azure App Service managed certificate

Obviously the third example can only work with Azure. The two others are written to work with Azure as well but can be adapted or used as an inspiration to work on other platforms.


## Getting started

### Set the variables of the root module

If you want to run this against your Azure infrastructure you will need to provide values for the variables of the root module:
- The `dns_zone_name` should contain the name of your DNS Zone managed in Azure
- The `dns_zone_rg_name` should contain the name of the resource group containing your DNS zone (defaults to `rg-dns` as it's what I use in my subscription)
- The `location` should contain the Azure region you want to use (defaults to `francecentral` as it's the closest in my case :croissant:)

### Add environment variables for Let's Encrypt

The Terraform ACME provider can be used with many DNS providers. I use Azure DNS in this repo, so the authentication requires adding a few environment variables as the provider does not get a token from the `az cli` signed in user.  
I have personally used a `.env` file which is git-ignored with a content like this:
```sh
export ARM_TENANT_ID="<YOUR AZURE TENAND ID (a guid)>"
export ARM_SUBSCRIPTION_ID="<YOUR AZURE SUBSCRIPTION ID (another guid)>"
export ARM_CLIENT_ID="<AN APP REGISTRATION ID (yep it's a guid too)>"
export ARM_CLIENT_SECRET="<THE APP REGISTRATION SECRET (not a guid this time)>"
```
Then using the `source .env` command the environment variables can be used by the ACME provider to temporary add records in your DNS zone to verify your ownership of the domain.  
Note that if your are running this in Terraform Cloud you can skip this step.

### Create the resources
Once everything is setup you should be able to run a `terraform init`, then a `terraform apply` to create the resources in your subscription.  

## Switch the certificate bound to the App Service
What's interesting to do with this little project is to change the certificate bound to the App Service custom domain.  
You can do this either in the Azure portal (in the TLS/SSL settings blade) or by changing the `certificate_id` argument here in the root module:
```hcl
resource "azurerm_app_service_certificate_binding" "cert_binding" {
  certificate_id      = module.self_signed.certificate_id # <-- Change this !
  hostname_binding_id = module.app_service.custom_domain_binding_id
  ssl_state           = "SniEnabled"
}
```
You can use one of the following values:
- `module.self_signed.certificate_id` to use the self-signed certificate
- `module.acme.certificate_id` to use the certificate from Let's Encrypt
- `module.managed.certificate_id` to use the managed certificate
