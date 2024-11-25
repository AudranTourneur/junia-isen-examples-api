# A Service Plan is the higher level concept which contains the actual app
resource "azurerm_service_plan" "main" {
  name                = "${var.resource_group_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P0v3" # The cheapest option
}

# The actual app
resource "azurerm_linux_web_app" "main" {
  name                          = "${var.resource_group_name}-app"
  resource_group_name           = var.resource_group_name
  location                      = azurerm_service_plan.main.location
  service_plan_id               = azurerm_service_plan.main.id
  public_network_access_enabled = true # required, this is a public facing application
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
    vnet_route_all_enabled = true # the app doesn't need to contact public IPs, we can restrict to the subnet
    application_stack {
      docker_registry_url = var.docker_registry_url
      docker_image_name   = var.docker_image_name
    }
  }

  # Let's create an identity for our app
  identity {
    type = "SystemAssigned"
  }
}

# Let's give a role to your app to access the blob storage
resource "azurerm_role_assignment" "role_assignment" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_web_app.main.identity[0].principal_id
}

# This is a managed service so we need to "delegate" the subnet to Microsoft
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

# Associate the subnet with our network security group
resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = var.network_security_group_id
}
