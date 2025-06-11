variable "kv_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault"
  type        = string
}

variable "allowed_subnet_ids" {
  description = "List of subnet IDs allowed to access the Key Vault"
  type        = list(string)
  default     = []
}

variable "allowed_ip_addresses" {
  description = "List of IP addresses allowed to access the Key Vault"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the Key Vault"
  type        = map(string)
  default     = {}
} 