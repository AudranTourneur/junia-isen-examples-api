variable "location" {
    description = "The location to deploy the Postgres database"
    type = string
}

variable resource_group_name {
    description = "The resource group to use, obtainable by a azurerm_resource_group"
    type = string
}