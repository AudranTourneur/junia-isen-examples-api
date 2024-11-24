variable "location" {
  type        = string
  default     = "francecentral"
  description = "Location of the resources"
}

variable "resource_group_name" {
  type        = string
  default     = "project_resource_group"
  description = "Name of the resource group in which all resource are grouped"
}

variable "subscription_id" {
  type        = string
  nullable    = false
  description = <<EOT
Your Azure subscription ID

To retrieve it:
az login --use-device-code
az account show --query='id' --output=tsv
EOT
}

variable "email_address" {
  type        = string
  nullable    = false
  description = "Your email address"
}

variable "database_name" {
  type        = string
  nullable    = false
  description = "Your database name"
  default     = "appdb"
}

variable "database_username" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Your database admin username"
}

variable "database_password" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Your database admin password"
}

variable "database_port" {
  type        = number
  nullable    = false
  description = "Your database port"
  default     = 5432
}
