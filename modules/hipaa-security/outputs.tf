output "encryption_key_id" {
  description = "ID of the customer-managed encryption key"
  value       = azurerm_key_vault_key.data_encryption.id
}

output "disk_encryption_set_id" {
  description = "ID of the disk encryption set"
  value       = azurerm_disk_encryption_set.main.id
}

output "hipaa_backup_storage_id" {
  description = "ID of the HIPAA-compliant backup storage account"
  value       = azurerm_storage_account.hipaa_backup.id
}

output "hipaa_backup_storage_name" {
  description = "Name of the HIPAA-compliant backup storage account"
  value       = azurerm_storage_account.hipaa_backup.name
}

output "private_endpoint_id" {
  description = "ID of the storage private endpoint"
  value       = azurerm_private_endpoint.storage_backup.id
}

output "backup_storage_primary_access_key" {
  description = "Primary access key for backup storage"
  value       = azurerm_storage_account.hipaa_backup.primary_access_key
  sensitive   = true
}

output "backup_storage_connection_string" {
  description = "Connection string for backup storage"
  value       = azurerm_storage_account.hipaa_backup.primary_connection_string
  sensitive   = true
} 