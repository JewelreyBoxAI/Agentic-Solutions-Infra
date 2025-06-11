output "tenant_name" {
  description = "Name of the dualcore-agent tenant"
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
  description = "FQDN of the DualCoreAgent Container App"
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
  description = "Endpoint of the Cosmos DB account for agent state"
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

output "application_insights_id" {
  description = "ID of the Application Insights instance"
  value       = azurerm_application_insights.dualcore_agent.id
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.dualcore_agent.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = azurerm_application_insights.dualcore_agent.connection_string
  sensitive   = true
}

output "dns_fqdn" {
  description = "DNS FQDN for dualcore-agent tenant"
  value       = "dualcore.agentic.solutions.local"
}

output "openai_api_key_secret_id" {
  description = "Key Vault secret ID for OpenAI API key"
  value       = azurerm_key_vault_secret.openai_api_key.id
  sensitive   = true
}

output "anthropic_api_key_secret_id" {
  description = "Key Vault secret ID for Anthropic API key"
  value       = azurerm_key_vault_secret.anthropic_api_key.id
  sensitive   = true
}

output "security_controls_enabled" {
  description = "Whether enhanced security controls are enabled"
  value       = var.enable_enhanced_security
}

output "enhanced_security_resource_ids" {
  description = "Resource IDs from enhanced security module"
  value       = var.enable_enhanced_security ? module.enhanced_security[0].security_resource_ids : null
}

output "agent_configuration" {
  description = "DualCoreAgent configuration summary"
  value = {
    openai_model    = var.openai_model
    anthropic_model = var.anthropic_model
    max_tokens      = var.max_tokens
    temperature     = var.temperature
    timeout         = var.request_timeout
    agent_count     = var.agent_count
    dapr_enabled    = var.dapr_enabled
  }
} 