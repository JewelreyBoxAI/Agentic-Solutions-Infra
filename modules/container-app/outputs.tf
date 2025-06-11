output "container_app_environment_id" {
  description = "ID of the Container App Environment"
  value       = azurerm_container_app_environment.main.id
}

output "container_app_environment_name" {
  description = "Name of the Container App Environment"
  value       = azurerm_container_app_environment.main.name
}

output "container_app_id" {
  description = "ID of the Container App"
  value       = azurerm_container_app.main.id
}

output "container_app_name" {
  description = "Name of the Container App"
  value       = azurerm_container_app.main.name
}

output "container_app_fqdn" {
  description = "FQDN of the Container App"
  value       = azurerm_container_app.main.latest_revision_fqdn
}

output "application_insights_id" {
  description = "ID of Application Insights (if Dapr enabled)"
  value       = var.dapr_enabled ? azurerm_application_insights.main[0].id : null
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights (if Dapr enabled)"
  value       = var.dapr_enabled ? azurerm_application_insights.main[0].connection_string : null
  sensitive   = true
} 