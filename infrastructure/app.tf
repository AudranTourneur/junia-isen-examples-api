resource "random_pet" "app_prefix" {
  prefix = var.database_name
  length = 1
}

resource "azurerm_service_plan" "example" {
  name                = "${random_pet.app_prefix.id}-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "P0v3"
}

resource "azurerm_linux_web_app" "example" {
  name                          = "${random_pet.app_prefix.id}-example"
  resource_group_name           = azurerm_resource_group.example.name
  location                      = azurerm_service_plan.example.location
  service_plan_id               = azurerm_service_plan.example.id
  public_network_access_enabled = true
  app_settings = {
    "DATABASE_HOST"          = azurerm_postgresql_flexible_server.default.fqdn
    "DATABASE_PORT"          = "5432"
    "DATABASE_NAME"          = "postgres"
    "DATABASE_USER"          = var.database_username
    "DATABASE_PASSWORD"      = var.database_password
  }
  virtual_network_subnet_id = azurerm_subnet.app.id

  site_config {
    vnet_route_all_enabled = true
    application_stack {
      docker_registry_url = "https://ghcr.io"
      docker_image_name   = "audrantourneur/junia-isen-examples-api/cloud-computing-app:latest"
    }
  }

  depends_on = [ azurerm_subnet.app, azurerm_subnet_network_security_group_association.app ]
}
