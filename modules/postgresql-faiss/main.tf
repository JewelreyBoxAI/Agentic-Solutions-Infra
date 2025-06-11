# PostgreSQL Flexible Server with pgvector for FAISS-style vector operations
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = var.postgresql_server_name
  resource_group_name    = var.resource_group_name
  location              = var.location
  version               = "15"
  delegated_subnet_id   = var.allowed_subnet_id
  private_dns_zone_id   = azurerm_private_dns_zone.postgresql.id
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  zone                  = "1"

  storage_mb = var.storage_mb
  sku_name   = var.sku_name

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  # HIPAA Enhancement: Security settings
  public_network_access_enabled = false

  tags = var.tags

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgresql]
}

# Private DNS Zone for PostgreSQL
resource "azurerm_private_dns_zone" "postgresql" {
  name                = "${var.postgresql_server_name}.private.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link private DNS zone to virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                  = "${var.postgresql_server_name}-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group_name
  registration_enabled  = false

  tags = var.tags
}

# PostgreSQL Configuration for pgvector extension
resource "azurerm_postgresql_flexible_server_configuration" "pgvector" {
  name      = "shared_preload_libraries"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "pgvector"
}

# PostgreSQL Configuration for logging (HIPAA requirement)
resource "azurerm_postgresql_flexible_server_configuration" "log_statement" {
  name      = "log_statement"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "all"
}

resource "azurerm_postgresql_flexible_server_configuration" "log_min_duration_statement" {
  name      = "log_min_duration_statement"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "0"
}

# Main database for agent data
resource "azurerm_postgresql_flexible_server_database" "agent_db" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Vector database for FAISS-style operations
resource "azurerm_postgresql_flexible_server_database" "vector_db" {
  name      = "${var.database_name}_vectors"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Diagnostic settings for HIPAA compliance
resource "azurerm_monitor_diagnostic_setting" "postgresql" {
  name                       = "${var.postgresql_server_name}-diagnostics"
  target_resource_id         = azurerm_postgresql_flexible_server.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "PostgreSQLLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  tags = var.tags
}

# PostgreSQL Firewall Rules (restrictive for HIPAA)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
} 