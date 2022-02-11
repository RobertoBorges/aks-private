# Private AKS Terraform
Manage a "Fully" private AKS infrastructure with Terraform.

![Full Architecture ](.\architecture.png "image Title")

# Update the main.tf

Replace the followind lines on your main.tf

```json

  backend "azurerm" {
    resource_group_name  = "infrapfeborges-rg"
    storage_account_name = "storagepfeborges"
    container_name       = "terraformdev"
    key                  = "production-terraform.state"
  }  

```

# Running the script
After you configure authentication with Azure, just init and apply (no inputs are required):

`terraform init`

`terraform apply`
