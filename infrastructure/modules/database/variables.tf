variable "username" {
  description = "The username to connect to the Postgres database"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "The password to connect to the Postgres database"
  type        = string
  sensitive   = true
}

variable "database" {
  description = "The name of the Postgres database"
  type        = string
}

variable "location" {
  description = "The location to deploy the Postgres database"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group to use, obtainable by a azurerm_resource_group"
  type        = string
}

variable "private_dns_zone_id" {
  description = "A private DNS zone ID, obtainable by a azurerm_private_dns_zone"
  type        = string
}

variable "virtual_network_name" {
  default = "The name virtual network to use"
  type    = string
}

variable "network_security_group_id" {
  description = "The ID of the network security group to use"
  type        = string
}
