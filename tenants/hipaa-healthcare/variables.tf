variable "tenant_name" {
  description = "Name of the HIPAA-compliant tenant"
  type        = string
  default     = "hipaa-healthcare"
}

variable "env_name" {
  description = "Name of the Container App Environment"
  type        = string
  default     = "hipaa-healthcare-env"
}

variable "app_name" {
  description = "Name of the Container App"
  type        = string
  default     = "hipaa-healthcare-app"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "hipaahealthcarecr"
}

variable "acr_username" {
  description = "Username for Azure Container Registry"
  type        = string
  sensitive   = true
}

variable "acr_password" {
  description = "Password for Azure Container Registry"
  type        = string
  sensitive   = true
}

variable "kv_name" {
  description = "Name of the HIPAA-compliant Key Vault"
  type        = string
  default     = "hipaa-healthcare-kv"
}

variable "cosmos_name" {
  description = "Name of the HIPAA-compliant Cosmos DB account"
  type        = string
  default     = "hipaa-healthcare-cosmos"
}

variable "law_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "hipaa-healthcare-law"
}

variable "agent_count" {
  description = "Number of agents to deploy"
  type        = number
  default     = 2
}

variable "dapr_enabled" {
  description = "Enable Dapr sidecar"
  type        = bool
  default     = true
}

variable "admin_ip_addresses" {
  description = "List of admin IP addresses allowed to access Key Vault"
  type        = list(string)
  default     = []
}

variable "security_contact_email" {
  description = "Email address for HIPAA security notifications"
  type        = string
  default     = "security@healthcare.example.com"
}

variable "security_contact_phone" {
  description = "Phone number for HIPAA security notifications"
  type        = string
  default     = "+1-555-0123"
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
  description = "Number of days to retain network flow logs for HIPAA audit"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to apply to all HIPAA resources"
  type        = map(string)
  default = {
    Environment        = "Production"
    Project           = "Agentic-Solutions"
    Tenant            = "hipaa-healthcare"
    Compliance        = "HIPAA"
    DataClassification = "PHI"
    SecurityLevel     = "High"
  }
} 