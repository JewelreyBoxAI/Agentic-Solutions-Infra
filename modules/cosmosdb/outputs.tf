output "cosmos_endpoint" {
  description = "Endpoint URL of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.endpoint
}

output "cosmos_name" {
  description = "Name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.name
}

output "cosmos_id" {
  description = "ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = var.resource_group_name
}

output "cosmos_primary_key" {
  description = "Primary key of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.primary_key
  sensitive   = true
}

output "cosmos_connection_strings" {
  description = "Connection strings for the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.connection_strings
  sensitive   = true
} 