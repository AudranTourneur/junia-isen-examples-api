resource "null_resource" "delay2" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

    depends_on = [azurerm_resource_group.example]
}

resource "azurerm_postgresql_flexible_server" "postgresql_flexible_server" {
  name                   = "example-psqlflexibleserver"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  version                = "12"
  administrator_login    = var.database_username
  administrator_password = var.database_password
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  
  public_network_access_enabled = true
  authentication {

    password_auth_enabled = true
  }

  depends_on = [null_resource.delay2]
}

resource "null_resource" "delay1" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [azurerm_postgresql_flexible_server.postgresql_flexible_server]
}

resource "azurerm_postgresql_flexible_server_database" "postgresql_flexible_server_database" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
  collation = "fr_FR.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }

  depends_on = [null_resource.delay1]
}