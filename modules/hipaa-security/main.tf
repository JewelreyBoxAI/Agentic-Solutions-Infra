# HIPAA Security Module - Enhanced Security Controls
# This module implements additional security controls required for HIPAA compliance

# Customer-managed encryption keys for data at rest
resource "azurerm_key_vault_key" "data_encryption" {
  name         = "${var.tenant_name}-data-encryption-key"
  key_vault_id = var.keyvault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  tags = var.tags
}

# Disk encryption set for enhanced data protection
resource "azurerm_disk_encryption_set" "main" {
  name                = "${var.tenant_name}-disk-encryption-set"
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.data_encryption.id

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Storage account for HIPAA-compliant backups with encryption
resource "azurerm_storage_account" "hipaa_backup" {
  name                = "${replace(var.tenant_name, "-", "")}hipaabackup"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier        = "Standard"
  account_replication_type = "GRS"

  # Enable encryption at rest
  encryption {
    services {
      blob {
        enabled = true
      }
      file {
        enabled = true
      }
    }
    source = "Microsoft.Keyvault"
    key_vault_key_id = azurerm_key_vault_key.data_encryption.id
  }

  # Enable secure transfer (HTTPS only)
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"

  # Disable public access
  public_network_access_enabled = false

  # Network rules for private access only
  network_rules {
    default_action = "Deny"
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  tags = merge(var.tags, {
    Purpose = "HIPAA-Backup"
    DataClassification = "PHI"
  })
}

# Private endpoint for storage account
resource "azurerm_private_endpoint" "storage_backup" {
  name                = "${var.tenant_name}-storage-backup-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.tenant_name}-storage-backup-psc"
    private_connection_resource_id = azurerm_storage_account.hipaa_backup.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Data Loss Prevention policy
resource "azurerm_security_center_setting" "data_export" {
  setting_name   = "MCAS"
  enabled        = true
}

# Advanced Threat Protection for storage
resource "azurerm_advanced_threat_protection" "storage_backup" {
  target_resource_id = azurerm_storage_account.hipaa_backup.id
  enabled            = true
}

# Diagnostic settings for audit logging
resource "azurerm_monitor_diagnostic_setting" "storage_backup" {
  name               = "${var.tenant_name}-storage-backup-diagnostics"
  target_resource_id = azurerm_storage_account.hipaa_backup.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# HIPAA-compliant retention policy
resource "azurerm_storage_management_policy" "hipaa_retention" {
  storage_account_id = azurerm_storage_account.hipaa_backup.id

  rule {
    name    = "hipaa-retention-rule"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = var.data_retention_days
      }
      snapshot {
        delete_after_days_since_creation_greater_than = var.data_retention_days
      }
    }
  }
}

# Alert for unauthorized access attempts
resource "azurerm_monitor_metric_alert" "unauthorized_access" {
  name                = "${var.tenant_name}-unauthorized-access-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_storage_account.hipaa_backup.id]
  description         = "Alert for potential unauthorized access to PHI data"

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Transactions"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = var.access_alert_threshold

    dimension {
      name     = "ResponseType"
      operator = "Include"
      values   = ["ClientError", "ServerError"]
    }
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}

# Network Watcher for traffic monitoring
resource "azurerm_network_watcher_flow_log" "hipaa_flow_log" {
  network_watcher_name = var.network_watcher_name
  resource_group_name  = var.resource_group_name
  name                 = "${var.tenant_name}-hipaa-flow-log"

  network_security_group_id = var.network_security_group_id
  storage_account_id        = azurerm_storage_account.hipaa_backup.id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace_id
    workspace_region      = var.location
    workspace_resource_id = var.log_analytics_workspace_id
  }

  tags = var.tags
} 