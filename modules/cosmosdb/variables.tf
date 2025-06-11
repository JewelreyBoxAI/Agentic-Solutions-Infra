variable "cosmos_name" {
  description = "Name of the Cosmos DB account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the Cosmos DB account"
  type        = string
}

variable "allowed_subnet_id" {
  description = "Subnet ID allowed to access Cosmos DB"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Cosmos DB account"
  type        = map(string)
  default     = {}
} 