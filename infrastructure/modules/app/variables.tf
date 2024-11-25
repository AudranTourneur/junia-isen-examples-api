variable "location" {
  description = "The location to deploy the application"
  type        = string
}

variable "database_host" {
  description = "The host as a FQDN of the target database"
  type        = string
}

variable "database_port" {
  description = "The port of the target database"
  type        = string
}

variable "database_name" {
  description = "The Postgres database of the target database"
  type        = string
}

variable "database_username" {
  description = "The username of the target database"
  type        = string
  sensitive   = true
}

variable "database_password" {
  description = "The pasword of the target database"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "The resource group containing the application"
  type        = string
}

variable "storage_blob_url" {
  description = "The URL of the storage blob container"
  type        = string
}

variable "storage_account_id" {
  description = "The storage account ID, obtainable by a azurerm_storage_account"
  type        = string
}

variable "virtual_network_name" {
  type = string
}

variable "docker_registry_url" {
  description = "The Docker registry URL"
  type        = string
}

variable "docker_image_name" {
  description = "The Docker image name"
  type        = string
}

variable "network_security_group_id" {
  description = "The ID of the network security group to assign to the app"
  type        = string
}
