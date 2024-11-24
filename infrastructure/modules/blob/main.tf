# A globally unique ID, the maximum allowed by Azure is 24 char with lowercase and numbers only
resource "random_string" "main" {
  length  = 24
  special = false
  upper   = false
}

# The storage account is the top-level unit which contains containers
resource "azurerm_storage_account" "main" {
  name                     = random_string.main.id
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Locally redundant storage, the cheapest option
}

# A storage container is akin to a folder
resource "azurerm_storage_container" "main" {
  name                  = "api" # Must precisely match what is defined in the Python application code
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "blob" # TODO: Switch back to "private" later
}

# A storage blob is akin to a file
resource "azurerm_storage_blob" "main" {
  name                   = "quotes.json"
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  type                   = "Block"
  source                 = "modules/blob/resources/quotes.json"
}
