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
  
  virtual_network_subnet_id = azurerm_subnet.app.id

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

resource "azurerm_role_assignment" "role_assignment" {
  scope               = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id        = azurerm_linux_web_app.main.identity[0].principal_id
}

resource "azurerm_subnet" "app" {
  name                 = "app-service-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "as"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = var.network_security_group_id
}