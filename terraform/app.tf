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
  name                = "${random_pet.app_prefix.id}-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    application_stack {
      docker_registry_url = "https://ghcr.io"
      docker_image_name = "audrantourneur/junia-isen-examples-api/cloud-computing-app:latest"
    }
  }
}
