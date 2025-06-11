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
    key                  = "dualcore-agent.tfstate"
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

# Reference to database subnet for enhanced security
data "azurerm_subnet" "database" {
  name                 = "subnet-database"
  virtual_network_name = data.azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.main.name
}

# Reference to private endpoints subnet
data "azurerm_subnet" "private_endpoints" {
  name                 = "subnet-private-endpoints"
  virtual_network_name = data.azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.main.name
}

# Log Analytics workspace for DualCoreAgent monitoring
module "log_analytics" {
  source = "../../modules/log-analytics"

  law_name            = var.law_name
  resource_group_name = data.azurerm_resource_group.main.name
  location           = data.azurerm_resource_group.main.location

  tags = var.tags
}

# Key Vault for API keys and secrets
module "keyvault" {
  source = "../../modules/keyvault"

  kv_name               = var.kv_name
  resource_group_name   = data.azurerm_resource_group.main.name
  location             = data.azurerm_resource_group.main.location
  allowed_subnet_ids   = [data.azurerm_subnet.database.id]
  allowed_ip_addresses = var.admin_ip_addresses

  tags = var.tags
}

# Cosmos DB for agent state and conversation history
module "cosmosdb" {
  source = "../../modules/cosmosdb"

  cosmos_name           = var.cosmos_name
  resource_group_name   = data.azurerm_resource_group.main.name
  location             = data.azurerm_resource_group.main.location
  allowed_subnet_id    = data.azurerm_subnet.database.id

  tags = var.tags
}

# Container Apps for DualCoreAgent deployment
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

# Enhanced security for AI agent operations
module "enhanced_security" {
  count  = var.enable_enhanced_security ? 1 : 0
  source = "../../modules/hipaa-security"

  tenant_name                   = var.tenant_name
  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  keyvault_id                  = module.keyvault.keyvault_id
  log_analytics_workspace_id   = module.log_analytics.workspace_id
  network_security_group_id    = data.azurerm_virtual_network.main.id
  network_watcher_name         = "agentic-network-watcher"
  allowed_subnet_ids           = [data.azurerm_subnet.database.id]
  private_endpoint_subnet_id   = data.azurerm_subnet.private_endpoints.id
  action_group_id              = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.main.name}/providers/Microsoft.Insights/actionGroups/agentic-hipaa-security-alerts"

  tags = var.tags
}

# Key Vault secrets for AI model API keys
resource "azurerm_key_vault_secret" "openai_api_key" {
  name         = "openai-api-key"
  value        = var.openai_api_key
  key_vault_id = module.keyvault.keyvault_id

  tags = var.tags

  depends_on = [module.keyvault]
}

resource "azurerm_key_vault_secret" "anthropic_api_key" {
  name         = "anthropic-api-key"
  value        = var.anthropic_api_key
  key_vault_id = module.keyvault.keyvault_id

  tags = var.tags

  depends_on = [module.keyvault]
}

# Application Insights for agent performance monitoring
resource "azurerm_application_insights" "dualcore_agent" {
  name                = "${var.tenant_name}-appinsights"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  workspace_id        = module.log_analytics.workspace_id
  application_type    = "web"

  tags = var.tags
}

# Get current client configuration
data "azurerm_client_config" "current" {} 