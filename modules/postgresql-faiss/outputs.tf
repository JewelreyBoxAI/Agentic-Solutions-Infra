output "postgresql_server_id" {
  description = "ID of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.id
}

output "postgresql_server_name" {
  description = "Name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "postgresql_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_connection_string" {
  description = "Connection string for PostgreSQL (without password)"
  value       = "host=${azurerm_postgresql_flexible_server.main.fqdn} port=5432 dbname=${azurerm_postgresql_flexible_server_database.agent_db.name} user=${var.admin_username} sslmode=require"
  sensitive   = true
}

output "vector_database_name" {
  description = "Name of the vector database for FAISS operations"
  value       = azurerm_postgresql_flexible_server_database.vector_db.name
}

output "main_database_name" {
  description = "Name of the main agent database"
  value       = azurerm_postgresql_flexible_server_database.agent_db.name
}

output "private_dns_zone_id" {
  description = "ID of the private DNS zone"
  value       = azurerm_private_dns_zone.postgresql.id
}

output "server_admin_login" {
  description = "Administrator login for PostgreSQL"
  value       = azurerm_postgresql_flexible_server.main.administrator_login
}

output "postgresql_version" {
  description = "PostgreSQL version"
  value       = azurerm_postgresql_flexible_server.main.version
} 