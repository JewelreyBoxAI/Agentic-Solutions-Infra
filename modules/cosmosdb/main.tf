resource "azurerm_cosmosdb_account" "main" {
  name                      = var.cosmos_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  offer_type               = "Standard"
  kind                     = "GlobalDocumentDB"
  enable_automatic_failover = false
  
  # HIPAA Enhancement: Enable encryption and security features
  public_network_access_enabled = false
  is_virtual_network_filter_enabled = true
  enable_multiple_write_locations = false

  capabilities {
    name = "EnableServerless"
  }
  
  # HIPAA Enhancement: Network restrictions
  virtual_network_rule {
    id                                   = var.allowed_subnet_id
    ignore_missing_vnet_service_endpoint = false
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = var.tags
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "${var.cosmos_name}-db"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name
}

resource "azurerm_cosmosdb_sql_container" "main" {
  name                  = "agents"
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.main.name
  database_name         = azurerm_cosmosdb_sql_database.main.name
  partition_key_path    = "/id"
  partition_key_version = 1

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/\"_etag\"/?"
    }
  }
} 