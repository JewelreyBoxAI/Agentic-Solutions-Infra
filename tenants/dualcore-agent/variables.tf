variable "tenant_name" {
  description = "Name of the dualcore-agent tenant"
  type        = string
  default     = "dualcore-agent"
}

variable "env_name" {
  description = "Name of the Container App Environment"
  type        = string
  default     = "dualcore-agent-env"
}

variable "app_name" {
  description = "Name of the Container App"
  type        = string
  default     = "dualcore-agent-app"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "dualcoreagentcr"
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
  default     = "dualcore-agent-kv"
}

variable "cosmos_name" {
  description = "Name of the Cosmos DB account"
  type        = string
  default     = "dualcore-agent-cosmos"
}

variable "law_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "dualcore-agent-law"
}

variable "agent_count" {
  description = "Number of DualCoreAgent instances to deploy"
  type        = number
  default     = 3
}

variable "dapr_enabled" {
  description = "Enable Dapr sidecar for microservices communication"
  type        = bool
  default     = true
}

variable "enable_enhanced_security" {
  description = "Enable enhanced security controls for AI operations"
  type        = bool
  default     = true
}

variable "admin_ip_addresses" {
  description = "List of admin IP addresses allowed to access Key Vault"
  type        = list(string)
  default     = []
}

variable "openai_api_key" {
  description = "OpenAI API key for GPT models"
  type        = string
  sensitive   = true
}

variable "anthropic_api_key" {
  description = "Anthropic API key for Claude models"
  type        = string
  sensitive   = true
}

variable "openai_model" {
  description = "OpenAI model to use (e.g., gpt-4, gpt-3.5-turbo)"
  type        = string
  default     = "gpt-4"
}

variable "anthropic_model" {
  description = "Anthropic model to use (e.g., claude-3-sonnet, claude-3-haiku)"
  type        = string
  default     = "claude-3-sonnet-20240229"
}

variable "max_tokens" {
  description = "Maximum tokens for AI model responses"
  type        = number
  default     = 4096
}

variable "temperature" {
  description = "Temperature setting for AI model creativity"
  type        = number
  default     = 0.7
}

variable "request_timeout" {
  description = "Request timeout for AI model calls (seconds)"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
    Tenant      = "dualcore-agent"
    Owner       = "AI Operations Team"
    Purpose     = "Dual-Core AI Agent Platform"
  }
} 