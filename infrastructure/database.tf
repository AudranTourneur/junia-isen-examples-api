resource "random_pet" "name_prefix" {
  prefix = var.database_name
  length = 1
}

locals {
  db_name = "${random_pet.name_prefix.id}-server"
}

resource "azurerm_postgresql_flexible_server" "default" {
  name                   = local.db_name
  resource_group_name    = azurerm_resource_group.example.name
  location               = var.location
  version                = "16"
  delegated_subnet_id    = azurerm_subnet.database.id
  private_dns_zone_id    = azurerm_private_dns_zone.default.id
  administrator_login    = var.database_username
  administrator_password = var.database_password
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  backup_retention_days  = 7
  public_network_access_enabled = false

  depends_on = [azurerm_private_dns_zone_virtual_network_link.default]
}

resource "azurerm_postgresql_flexible_server_database" "default" {
  name      = "${random_pet.name_prefix.id}-db"
  server_id = azurerm_postgresql_flexible_server.default.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}
