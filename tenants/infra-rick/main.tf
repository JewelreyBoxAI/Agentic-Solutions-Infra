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
    key                  = "infra-rick.tfstate"
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

# Log Analytics workspace
module "log_analytics" {
  source = "../../modules/log-analytics"

  law_name            = var.law_name
  resource_group_name = data.azurerm_resource_group.main.name
  location           = data.azurerm_resource_group.main.location

  tags = var.tags
}

# Key Vault with enhanced security
module "keyvault" {
  source = "../../modules/keyvault"

  kv_name               = var.kv_name
  resource_group_name   = data.azurerm_resource_group.main.name
  location             = data.azurerm_resource_group.main.location
  allowed_subnet_ids   = [data.azurerm_subnet.database.id]
  allowed_ip_addresses = var.admin_ip_addresses

  tags = var.tags
}

# PostgreSQL with pgvector for infrastructure monitoring data and FAISS operations
module "postgresql_faiss" {
  source = "../../modules/postgresql-faiss"

  postgresql_server_name       = var.postgresql_server_name
  resource_group_name          = data.azurerm_resource_group.main.name
  location                    = data.azurerm_resource_group.main.location
  admin_username              = var.postgresql_admin_username
  admin_password              = var.postgresql_admin_password
  database_name               = var.database_name
  allowed_subnet_id           = data.azurerm_subnet.database.id
  virtual_network_id          = data.azurerm_virtual_network.main.id
  log_analytics_workspace_id  = module.log_analytics.workspace_id

  tags = var.tags
}

# Container Apps with Dapr integration - powered by DualCoreAgent
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
  postgresql_server_name      = module.postgresql_faiss.postgresql_server_name
  postgresql_connection_string = module.postgresql_faiss.postgresql_connection_string
  vector_database_name        = module.postgresql_faiss.vector_database_name
  log_analytics_workspace_id  = module.log_analytics.workspace_id
  agent_count                 = var.agent_count
  dapr_enabled                = var.dapr_enabled

  tags = var.tags
}

# Reference to DualCoreAgent tenant for maintenance operations
data "terraform_remote_state" "dualcore_agent" {
  backend = "azurerm"
  config = {
    resource_group_name  = "AgenticInfra-rg"
    storage_account_name = "agenticsolsstg"
    container_name       = "tfstate"
    key                  = "dualcore-agent.tfstate"
  }
}

# Key Vault secrets for DualCoreAgent integration
resource "azurerm_key_vault_secret" "dualcore_agent_endpoint" {
  name         = "dualcore-agent-endpoint"
  value        = data.terraform_remote_state.dualcore_agent.outputs.container_app_fqdn
  key_vault_id = module.keyvault.keyvault_id

  tags = var.tags

  depends_on = [module.keyvault]
}

# Application Insights for maintenance operations monitoring
resource "azurerm_application_insights" "infra_rick_maintenance" {
  name                = "${var.tenant_name}-maintenance-appinsights"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  workspace_id        = module.log_analytics.workspace_id
  application_type    = "web"

  tags = merge(var.tags, {
    Component = "Maintenance Operations"
    PoweredBy = "DualCoreAgent"
  })
}

# Optional: Enhanced security for sensitive workloads
module "enhanced_security" {
  count  = var.enable_enhanced_security ? 1 : 0
  source = "../../modules/hipaa-security"

  tenant_name                   = var.tenant_name
  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  keyvault_id                  = module.keyvault.keyvault_id
  log_analytics_workspace_id   = module.log_analytics.workspace_id
  network_security_group_id    = data.azurerm_virtual_network.main.id  # This should reference the actual NSG
  network_watcher_name         = "agentic-network-watcher"
  allowed_subnet_ids           = [data.azurerm_subnet.database.id]
  private_endpoint_subnet_id   = data.azurerm_subnet.private_endpoints.id
  action_group_id              = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.main.name}/providers/Microsoft.Insights/actionGroups/agentic-hipaa-security-alerts"

  tags = var.tags
}

# Get current client configuration
data "azurerm_client_config" "current" {} 