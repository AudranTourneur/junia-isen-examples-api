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
    "NEW_RELIC_LICENSE_KEY" = var.new_relic_license_key
    "NEW_RELIC_APP_NAME"    = var.new_relic_app_name
  }
  virtual_network_subnet_id = var.virtual_network_subnet_id

  site_config {
    vnet_route_all_enabled = true
    application_stack {
      docker_registry_url = var.docker_registry_url
      docker_image_name   = var.docker_image_name
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_web_app.main.identity[0].principal_id
}
