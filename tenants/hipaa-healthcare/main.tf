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
    key                  = "hipaa-healthcare.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Reference to global resource group
data "azurerm_resource_group" "main" {
  name = "AgenticInfra-rg"
}

# Reference to global virtual network and subnets
data "azurerm_virtual_network" "main" {
  name                = "agentic-vnet"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "database" {
  name                 = "subnet-database"
  virtual_network_name = data.azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "private_endpoints" {
  name                 = "subnet-private-endpoints"
  virtual_network_name = data.azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.main.name
}

data "azurerm_network_watcher" "main" {
  name                = "agentic-network-watcher"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_monitor_action_group" "hipaa_security" {
  name                = "agentic-hipaa-security-alerts"
  resource_group_name = data.azurerm_resource_group.main.name
}

# Log Analytics workspace
module "log_analytics" {
  source = "../../modules/log-analytics"

  law_name            = var.law_name
  resource_group_name = data.azurerm_resource_group.main.name
  location           = data.azurerm_resource_group.main.location

  tags = merge(var.tags, {
    DataClassification = "PHI"
    Compliance         = "HIPAA"
  })
}

# HIPAA-compliant Key Vault
module "keyvault" {
  source = "../../modules/keyvault"

  kv_name               = var.kv_name
  resource_group_name   = data.azurerm_resource_group.main.name
  location             = data.azurerm_resource_group.main.location
  allowed_subnet_ids   = [data.azurerm_subnet.database.id]
  allowed_ip_addresses = var.admin_ip_addresses

  tags = merge(var.tags, {
    DataClassification = "PHI"
    Compliance         = "HIPAA"
  })
}

# HIPAA-compliant Cosmos DB
module "cosmosdb" {
  source = "../../modules/cosmosdb"

  cosmos_name           = var.cosmos_name
  resource_group_name   = data.azurerm_resource_group.main.name
  location             = data.azurerm_resource_group.main.location
  allowed_subnet_id    = data.azurerm_subnet.database.id

  tags = merge(var.tags, {
    DataClassification = "PHI"
    Compliance         = "HIPAA"
  })
}

# HIPAA Security Controls
module "hipaa_security" {
  source = "../../modules/hipaa-security"

  tenant_name                   = var.tenant_name
  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  keyvault_id                  = module.keyvault.keyvault_id
  log_analytics_workspace_id   = module.log_analytics.workspace_id
  network_security_group_id    = data.azurerm_virtual_network.main.id  # This should be NSG ID
  network_watcher_name         = data.azurerm_network_watcher.main.name
  allowed_subnet_ids           = [data.azurerm_subnet.database.id]
  private_endpoint_subnet_id   = data.azurerm_subnet.private_endpoints.id
  action_group_id              = data.azurerm_monitor_action_group.hipaa_security.id
  data_retention_days          = var.data_retention_days
  flow_log_retention_days      = var.flow_log_retention_days

  tags = merge(var.tags, {
    DataClassification = "PHI"
    Compliance         = "HIPAA"
  })
}

# Container Apps with enhanced security
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

  tags = merge(var.tags, {
    DataClassification = "PHI"
    Compliance         = "HIPAA"
  })
}

# HIPAA Compliance: Backup and Recovery
resource "azurerm_backup_vault" "hipaa" {
  name                = "${var.tenant_name}-backup-vault"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  datastore_type      = "VaultStore"
  redundancy          = "GeoRedundant"

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, {
    Purpose            = "HIPAA-Backup"
    DataClassification = "PHI"
  })
}

# HIPAA Compliance: Automated backup policy
resource "azurerm_data_protection_backup_policy_blob_storage" "hipaa" {
  name     = "${var.tenant_name}-hipaa-backup-policy"
  vault_id = azurerm_backup_vault.hipaa.id

  backup_rule {
    name = "HIPAABackupRule"
    
    backup {
      frequency         = "Daily"
      interval          = 1
      time              = "23:00"
      time_zone         = "UTC"
    }
    
    retention {
      duration = "P${var.data_retention_days}D"
    }
  }
}

# HIPAA Compliance: Security monitoring and alerting
resource "azurerm_security_center_contact" "hipaa" {
  email = var.security_contact_email
  phone = var.security_contact_phone

  alert_notifications = true
  alerts_to_admins    = true
}

# HIPAA Compliance: Diagnostic settings for all resources
resource "azurerm_monitor_diagnostic_setting" "cosmos_hipaa" {
  name               = "${var.tenant_name}-cosmos-hipaa-diagnostics"
  target_resource_id = module.cosmosdb.cosmos_id
  log_analytics_workspace_id = module.log_analytics.workspace_id

  enabled_log {
    category = "DataPlaneRequests"
  }

  enabled_log {
    category = "MongoRequests"
  }

  enabled_log {
    category = "QueryRuntimeStatistics"
  }

  enabled_log {
    category = "PartitionKeyStatistics"
  }

  metric {
    category = "Requests"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "keyvault_hipaa" {
  name               = "${var.tenant_name}-keyvault-hipaa-diagnostics"
  target_resource_id = module.keyvault.keyvault_id
  log_analytics_workspace_id = module.log_analytics.workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
} 