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
  public_network_access_enabled = false # Important: The database should never be reachable from the public Internet
  delegated_subnet_id           = azurerm_subnet.database.id
  private_dns_zone_id           = var.private_dns_zone_id # Important so that other services can find us by a private DNS query
  zone                          = "3"                     # Arbitrary choice
}

# A Flexible Postgres server may contain many databases, a single one is enough for our application
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = var.database
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

# Just like the app, this is a managed service so we need to "delegate" the subnet to Microsoft
resource "azurerm_subnet" "database" {
  name                 = "${var.resource_group_name}-database-subnet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# This exists to link our subnet to our Network Security Group
resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = var.network_security_group_id
}
