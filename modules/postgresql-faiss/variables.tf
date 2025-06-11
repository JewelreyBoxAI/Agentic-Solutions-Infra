variable "postgresql_server_name" {
  description = "Name of the PostgreSQL server"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the PostgreSQL server"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for PostgreSQL"
  type        = string
  default     = "pgadmin"
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Name of the main database"
  type        = string
  default     = "agents"
}

variable "sku_name" {
  description = "SKU name for PostgreSQL server"
  type        = string
  default     = "GP_Standard_D2s_v3"
}

variable "storage_mb" {
  description = "Storage size in MB"
  type        = number
  default     = 32768
}

variable "backup_retention_days" {
  description = "Backup retention in days"
  type        = number
  default     = 35
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backups"
  type        = bool
  default     = true
}

variable "allowed_subnet_id" {
  description = "Subnet ID for private networking"
  type        = string
}

variable "virtual_network_id" {
  description = "Virtual Network ID for DNS zone linking"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for diagnostics"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 