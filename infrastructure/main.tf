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
  private_dns_zone_id = module.network.private_dns_zone_id
  virtual_network_name = module.network.virtual_network_name
  network_security_group_id = module.network.network_security_group_id

  depends_on = [module.network]
}

module "blob" {
  source              = "./modules/blob"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  /*
  virtual_network_name = module.network.virtual_network_name
  network_security_group_id = module.network.network_security_group_id
  private_dns_zone_name = module.network.private_dns_zone_name
  private_dns_zone_id = module.network.private_dns_zone_id
  */
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
  virtual_network_name      = module.network.virtual_network_name
  network_security_group_id = module.network.network_security_group_id
  docker_registry_url       = var.docker_registry_url
  docker_image_name         = var.docker_image_name

  depends_on = [module.database, module.blob, module.network]
}

module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
}
