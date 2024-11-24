variable "location" {
  type        = string
  default     = "francecentral"
  description = "Location of the resources"
}

variable "resource_group_name" {
  type        = string
  default     = "project-resource-group"
  description = "Name of the resource group in which all resource are grouped. Use only alphanumeric and dashes."
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
  default     = 5432
  description = "Your database port"
}

variable "docker_registry_url" {
  type        = string
  nullable    = false
  default     = "https://ghcr.io"
  description = "The Docker registry URL"
}

variable "docker_image_name" {
  type        = string
  nullable    = false
  default     = "audrantourneur/junia-isen-examples-api/cloud-computing-app:latest"
  description = "The Docker image name"
}
