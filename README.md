# Certificate generation with Terraform for Azure App Service

This repository contains sample code to generate TLS certificates using Terraform.  
It uses an Azure App Service as an example of a website to secure.

The certificates are generated in 3 ways:
1. By creating a self-signed certificate
2. By requesting a certificate from Let's Encrypt
3. By creating an Azure App Service managed certificate

Obviously the third example can only work with Azure. The two others are written to work with Azure as well but can be adapted or used as an inspiration to work on other platforms.


## Getting started

### Set some variables

If you want to run this against your Azure infrastructure you will need to provide values for these variables:
- The `dns_zone_name` should contain the name of your DNS Zone managed in Azure
- The `dns_zone_rg_name` should contain the name of the resource group containing your DNS zone (defaults to `rg-dns` as it's what I use in my subscription)
- The `location` should contain the Azure region you want to use (defaults to `francecentral` as it's the closest in my case :croissant:)

Also the Terraform AzureRm provider requires the subscription id to be set as an argument. I prefer to use the `ARM_SUBSCRIPTION_ID` environment variable rather than putting a subscription id in the repo.  

So for all these variables I personally use a `.env` file which is git-ignored with a content like this:
```sh
export TF_VAR_dns_zone_name="<YOUR DNS ZONE NAME>"
export TF_VAR_dns_zone_rg_name="<RESOURCE GROUP NAME>"

export ARM_SUBSCRIPTION_ID="<YOUR AZURE SUBSCRIPTION ID (a guid)>"
```
Then using the `source .env` command the environment variables are used by Terraform's provider to access the resources.  
Note that if your are running this in Terraform Cloud you can skip this step, as the variables are set at the Terraform Cloud's workspace level.

### Create the resources
Once everything is setup you should be able to run a `terraform init`, then a `terraform apply` to create the resources in your subscription.  

## Switch the certificate bound to the App Service
What's interesting to do with this little project is to change the certificate bound to the App Service custom domain.  
You can do this either in the Azure portal (in the TLS/SSL settings blade) or by changing the value of the `binding_cert` variable and applying the changes again. The value can be either `self_signed` (default), `acme` or `managed`.
