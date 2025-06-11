output "tenant_name" {
  description = "Name of the infra-rick tenant"
  value       = var.tenant_name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.main.name
}

output "container_app_env_id" {
  description = "ID of the Container App Environment"
  value       = module.container_app.container_app_env_id
}

output "container_app_fqdn" {
  description = "FQDN of the Container App"
  value       = module.container_app.container_app_fqdn
}

output "keyvault_id" {
  description = "ID of the Key Vault"
  value       = module.keyvault.keyvault_id
}

output "keyvault_uri" {
  description = "URI of the Key Vault"
  value       = module.keyvault.keyvault_vault_uri
}

output "postgresql_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = module.postgresql_faiss.postgresql_fqdn
}

output "postgresql_connection_string" {
  description = "Connection string for PostgreSQL server"
  value       = module.postgresql_faiss.postgresql_connection_string
  sensitive   = true
}

output "vector_database_name" {
  description = "Name of the vector database for FAISS operations"
  value       = module.postgresql_faiss.vector_database_name
}

output "main_database_name" {
  description = "Name of the main database"
  value       = module.postgresql_faiss.main_database_name
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = module.log_analytics.workspace_id
}

output "log_analytics_primary_shared_key" {
  description = "Primary shared key for Log Analytics workspace"
  value       = module.log_analytics.primary_shared_key
  sensitive   = true
}

output "dns_fqdn" {
  description = "DNS FQDN for infra-rick tenant"
  value       = "rick.agentic.solutions.local"
}

output "security_controls_enabled" {
  description = "Whether enhanced security controls are enabled"
  value       = var.enable_enhanced_security
}

output "enhanced_security_resource_ids" {
  description = "Resource IDs from enhanced security module"
  value       = var.enable_enhanced_security ? module.enhanced_security[0].security_resource_ids : null
} 