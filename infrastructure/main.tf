data "azurerm_subscription" "current" {
}

data "azuread_user" "user" {
  user_principal_name = var.email_address
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

module "database" {
  source              = "./database"
  username            = var.database_username
  password            = var.database_password
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  private_dns_zone_id = azurerm_private_dns_zone.default.id
  delegated_subnet_id = azurerm_subnet.database.id

  depends_on = [azurerm_private_dns_zone_virtual_network_link.default ]
}
