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

output "cosmos_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = module.cosmosdb.cosmos_endpoint
  sensitive   = true
}

output "cosmos_primary_key" {
  description = "Primary key of the Cosmos DB account"
  value       = module.cosmosdb.cosmos_primary_key
  sensitive   = true
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