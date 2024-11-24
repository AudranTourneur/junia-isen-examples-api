resource "random_uuid" "main" {}

# The database name must be globally unique, so let's use a UUID
locals {
  db_name = "${random_uuid.main.id}-db"
}

# The Flexible Postgres server itself
resource "azurerm_postgresql_flexible_server" "main" {
  name                          = local.db_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "16" # Latest stable available PostgreSQL version, we live on the edge
  administrator_login           = var.username
  administrator_password        = var.password
  storage_mb                    = 32768             # 32GB, the minimum available
  sku_name                      = "B_Standard_B1ms" # The cheapest option
  backup_retention_days         = 7
  public_network_access_enabled = false                   # The database should never be reachable over the public Internet
  delegated_subnet_id           = var.delegated_subnet_id # Which subnet should we delegate to the private network
  private_dns_zone_id           = var.private_dns_zone_id # Important so that other services can find us by a private DNS query
  zone                          = "3"                     # Arbitrary choice
}

# A Flexible Postgres server may contain many databases, a single one is enough for our application
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "app"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}
