resource "random_pet" "prefix" {
  prefix = var.resource_group_name
  length = 1
}

resource "azurerm_service_plan" "main" {
  name                = "${random_pet.prefix.id}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P0v3" # The cheapest option
}

resource "azurerm_linux_web_app" "main" {
  name                          = "${random_pet.prefix.id}-app"
  resource_group_name           = var.resource_group_name
  location                      = azurerm_service_plan.main.location
  service_plan_id               = azurerm_service_plan.main.id
  public_network_access_enabled = true
  app_settings = {
    "DATABASE_HOST"       = var.database_host
    "DATABASE_PORT"       = var.database_port
    "DATABASE_NAME"       = var.database_name
    "DATABASE_USER"       = var.database_username
    "DATABASE_PASSWORD"   = var.database_password
    "STORAGE_ACCOUNT_URL" = var.storage_blob_url
  }
  virtual_network_subnet_id = var.virtual_network_subnet_id

  site_config {
    vnet_route_all_enabled = true
    application_stack {
      docker_registry_url = "https://ghcr.io"
      docker_image_name   = "audrantourneur/junia-isen-examples-api/cloud-computing-app:latest"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}
