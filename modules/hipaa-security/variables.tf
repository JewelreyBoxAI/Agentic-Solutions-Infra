variable "tenant_name" {
  description = "Name of the tenant for HIPAA compliance resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "keyvault_id" {
  description = "ID of the Key Vault for encryption keys"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace for audit logging"
  type        = string
}

variable "network_security_group_id" {
  description = "ID of the Network Security Group for flow logging"
  type        = string
}

variable "network_watcher_name" {
  description = "Name of the Network Watcher for flow logs"
  type        = string
}

variable "allowed_subnet_ids" {
  description = "List of subnet IDs allowed to access storage"
  type        = list(string)
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoints"
  type        = string
}

variable "action_group_id" {
  description = "Action group ID for security alerts"
  type        = string
}

variable "data_retention_days" {
  description = "Number of days to retain HIPAA data (minimum 6 years = 2190 days)"
  type        = number
  default     = 2190
  
  validation {
    condition     = var.data_retention_days >= 2190
    error_message = "HIPAA requires minimum 6 years (2190 days) data retention."
  }
}

variable "flow_log_retention_days" {
  description = "Number of days to retain network flow logs"
  type        = number
  default     = 90
}

variable "access_alert_threshold" {
  description = "Threshold for unauthorized access alerts"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags to apply to all HIPAA security resources"
  type        = map(string)
  default     = {}
} 