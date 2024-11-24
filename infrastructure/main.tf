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
  source              = "./modules/database"
  username            = var.database_username
  password            = var.database_password
  database            = var.database_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  private_dns_zone_id = azurerm_private_dns_zone.default.id
  delegated_subnet_id = azurerm_subnet.database.id

  depends_on = [azurerm_private_dns_zone_virtual_network_link.default]
}

module "blob" {
  source              = "./modules/blob"
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "app" {
  source                    = "./modules/app"
  location                  = var.location
  database_host             = module.database.fqdn
  database_username         = var.database_username
  database_password         = var.database_password
  database_name             = var.database_name
  database_port             = var.database_port
  resource_group_name       = var.resource_group_name
  storage_blob_url          = module.blob.url
  virtual_network_subnet_id = azurerm_subnet.app.id

  depends_on = [module.database, module.blob, azurerm_subnet.app, azurerm_subnet_network_security_group_association.app]
}

output "url" {
  description = "The deployed URL of the application"
  value       = module.app.url
}
