terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "AgenticInfra-rg"
    storage_account_name = "agenticsolsstg"
    container_name       = "tfstate"
    key                  = "impact-realty.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Reference to global resource group
data "azurerm_resource_group" "main" {
  name = "AgenticInfra-rg"
}

# Reference to global virtual network
data "azurerm_virtual_network" "main" {
  name                = "agentic-vnet"
  resource_group_name = data.azurerm_resource_group.main.name
}

# Log Analytics workspace
module "log_analytics" {
  source = "../../modules/log-analytics"

  law_name            = var.law_name
  resource_group_name = data.azurerm_resource_group.main.name
  location           = data.azurerm_resource_group.main.location

  tags = var.tags
}

# Key Vault
module "keyvault" {
  source = "../../modules/keyvault"

  kv_name             = var.kv_name
  resource_group_name = data.azurerm_resource_group.main.name
  location           = data.azurerm_resource_group.main.location

  tags = var.tags
}

# Cosmos DB
module "cosmosdb" {
  source = "../../modules/cosmosdb"

  cosmos_name         = var.cosmos_name
  resource_group_name = data.azurerm_resource_group.main.name
  location           = data.azurerm_resource_group.main.location

  tags = var.tags
}

# Container Apps
module "container_app" {
  source = "../../modules/container-app"

  env_name                     = var.env_name
  app_name                     = var.app_name
  location                    = data.azurerm_resource_group.main.location
  resource_group_name         = data.azurerm_resource_group.main.name
  acr_name                    = var.acr_name
  acr_username                = var.acr_username
  acr_password                = var.acr_password
  keyvault_name               = module.keyvault.keyvault_name
  keyvault_url                = module.keyvault.keyvault_vault_uri
  cosmosdb_name               = module.cosmosdb.cosmos_name
  cosmosdb_endpoint           = module.cosmosdb.cosmos_endpoint
  cosmosdb_key                = module.cosmosdb.cosmos_primary_key
  log_analytics_workspace_id  = module.log_analytics.workspace_id
  agent_count                 = var.agent_count
  dapr_enabled                = var.dapr_enabled

  tags = var.tags
} 