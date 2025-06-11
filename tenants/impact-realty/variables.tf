variable "env_name" {
  description = "Name of the Container App Environment"
  type        = string
  default     = "impact-env"
}

variable "app_name" {
  description = "Name of the Container App"
  type        = string
  default     = "impact-realty-app"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "impactrealtycr"
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
  default     = "impact-realty-kv"
}

variable "cosmos_name" {
  description = "Name of the Cosmos DB account"
  type        = string
  default     = "impact-realty-cosmos"
}

variable "law_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "impact-realty-law"
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

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
    Tenant      = "impact-realty"
  }
} 