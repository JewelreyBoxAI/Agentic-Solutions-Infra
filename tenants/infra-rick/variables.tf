variable "tenant_name" {
  description = "Name of the infra-rick tenant"
  type        = string
  default     = "infra-rick"
}

variable "env_name" {
  description = "Name of the Container App Environment"
  type        = string
  default     = "infra-rick-env"
}

variable "app_name" {
  description = "Name of the Container App"
  type        = string
  default     = "infra-rick-app"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "infrarickcr"
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
  description = "Name of the Key Vault"
  type        = string
  default     = "infra-rick-kv"
}

variable "cosmos_name" {
  description = "Name of the Cosmos DB account"
  type        = string
  default     = "infra-rick-cosmos"
}

variable "law_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "infra-rick-law"
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

variable "enable_enhanced_security" {
  description = "Enable enhanced security controls (HIPAA-level)"
  type        = bool
  default     = false
}

variable "admin_ip_addresses" {
  description = "List of admin IP addresses allowed to access Key Vault"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
    Tenant      = "infra-rick"
    Owner       = "Rick Infrastructure Team"
  }
} 