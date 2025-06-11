variable "env_name" {
  description = "Name of the Container App Environment"
  type        = string
}

variable "app_name" {
  description = "Name of the Container App"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
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

variable "image_name" {
  description = "Container image name"
  type        = string
  default     = "app"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

variable "keyvault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
}

variable "keyvault_url" {
  description = "URL of the Azure Key Vault"
  type        = string
}

variable "cosmosdb_name" {
  description = "Name of the Cosmos DB account"
  type        = string
}

variable "cosmosdb_endpoint" {
  description = "Cosmos DB endpoint URL"
  type        = string
}

variable "cosmosdb_key" {
  description = "Cosmos DB primary key"
  type        = string
  sensitive   = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
}

variable "agent_count" {
  description = "Number of agents to deploy"
  type        = number
  default     = 1
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
  default     = 3
}

variable "cpu" {
  description = "CPU allocation for container"
  type        = string
  default     = "0.25"
}

variable "memory" {
  description = "Memory allocation for container"
  type        = string
  default     = "0.5Gi"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080
}

variable "dapr_enabled" {
  description = "Enable Dapr sidecar"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 