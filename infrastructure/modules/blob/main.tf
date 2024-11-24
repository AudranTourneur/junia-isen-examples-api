# A globally unique ID, the maximum allowed by Azure is 24 char with lowercase and numbers only
resource "random_string" "main" {
  length  = 24
  special = false
  upper   = false
}

# The storage account is the top-level unit which contains containers
resource "azurerm_storage_account" "main" {
  name                          = random_string.main.id
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
}

# A storage container is akin to a folder
resource "azurerm_storage_container" "main" {
  name                  = "api" # Must precisely match what is defined in the Python application code
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

# A storage blob is akin to a file
resource "azurerm_storage_blob" "main" {
  name                   = "quotes.json"
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  type                   = "Block"
  source                 = "modules/blob/resources/quotes.json"
}


resource "azurerm_subnet" "blob" {
  name                 = "blob-service-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.3.0/24"]

  service_endpoints = ["Microsoft.Storage"]
}

/* Tentative de configuration de la sécurité du stockage en passant par un subnet (echec)
resource "azurerm_storage_account_network_rules" "main" {
  storage_account_id = azurerm_storage_account.main.id

  default_action     = "Deny"
  virtual_network_subnet_ids = [azurerm_subnet.blob.id]

  depends_on = [
    azurerm_storage_account.main,
    azurerm_storage_blob.main,
    azurerm_subnet.blob
  ]
}

resource "azurerm_subnet_network_security_group_association" "blob" {
  subnet_id                 = azurerm_subnet.blob.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_private_endpoint" "example" {
  name                = "example-private-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = azurerm_subnet.blob.id

  private_service_connection {
    name                           = "storage-private-connection"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = ["blob"] # Specify the blob service
  }

    private_dns_zone_group {
    name                 = "dns-group-sta"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

resource "azurerm_private_dns_a_record" "dns_a_sta" {
  name                = "a_record"
  zone_name           = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.example.private_service_connection.0.private_ip_address]
}
*/
