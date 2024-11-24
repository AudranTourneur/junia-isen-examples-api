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
  resource_group_name = azurerm_resource_group.example.name
}

module "app" {
  source                    = "./modules/app"
  location                  = var.location
  database_host             = module.database.fqdn
  database_username         = var.database_username
  database_password         = var.database_password
  database_name             = var.database_name
  database_port             = var.database_port
  resource_group_name       = azurerm_resource_group.example.name
  storage_blob_url          = module.blob.url
  storage_account_id        = module.blob.storage_account_id
  virtual_network_subnet_id = azurerm_subnet.app.id
  docker_registry_url       = var.docker_registry_url
  docker_image_name         = var.docker_image_name

  depends_on = [module.database, module.blob, azurerm_subnet.app, azurerm_subnet_network_security_group_association.app]
}

output "url" {
  description = "The deployed URL of the application"
  value       = module.app.url
}

output "app_publish_profile_name" {
  description = "Publish profile name"
  value       = module.app.publish_profile_name
  sensitive = true
}

output "app_publish_profile_password" {
  description = "Publish profile password"
  value       = module.app.publish_profile_password
  sensitive = true
}

output "app_name" {
  description = "App name"
  value       = module.app.name
}
