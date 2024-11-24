variable "username" {
    description = "The username to connect to the Postgres database"
    type = string
    sensitive = true
}

variable "password" {
    description = "The password to connect to the Postgres database"
    type = string
    sensitive = true
}

variable "location" {
    description = "The location to deploy the Postgres database"
    type = string
}

variable resource_group_name {
    description = "The resource group to use, obtainable by a azurerm_resource_group"
    type = string
}

variable "delegated_subnet_id" {
    description = "A delegated sub-network ID, obtainable by a azurerm_subnet"
    type = string
}

variable "private_dns_zone_id" {
    description = "A private DNS zone ID, obtainable by a azurerm_private_dns_zone"
    type = string
}
