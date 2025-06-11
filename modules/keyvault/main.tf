data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90  # HIPAA compliance - increased retention
  purge_protection_enabled    = true

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]

    storage_permissions = [
      "Get",
      "List",
      "Update",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]
  }

  # HIPAA Enhancement: Restrict network access to Key Vault
  network_acls {
    bypass                     = "AzureServices"
    default_action            = "Deny"
    virtual_network_subnet_ids = var.allowed_subnet_ids
    ip_rules                  = var.allowed_ip_addresses
  }

  # HIPAA Enhancement: Enable advanced features
  purge_protection_enabled      = true
  soft_delete_retention_days   = 90  # Increased for HIPAA compliance

  tags = var.tags
} 