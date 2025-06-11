terraform {
  backend "azurerm" {
    resource_group_name  = "AgenticInfra-rg"
    storage_account_name = "agenticsolsstg"
    container_name       = "tfstate"
    key                  = "globals.tfstate"
  }
} 