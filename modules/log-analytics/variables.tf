variable "law_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the Log Analytics workspace"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Log Analytics workspace"
  type        = map(string)
  default     = {}
} 