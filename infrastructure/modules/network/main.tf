resource "azurerm_virtual_network" "default" {
  name                = "mallard-vnet" # name is arbitrary
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_security_group" "default" {
  name                = "mallard-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # This security rule is coming from the official documentation and allows inbound traffic 
  # It does NOT expose the database 
  security_rule {
    name                       = "main"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Our private DNS zone so that each service can reach the others
resource "azurerm_private_dns_zone" "default" {
  name                = "pdz.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

# This exists solely to link our Private DNS zone to our main virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "db-pdzvnetlink.com" # name is arbitrary
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = azurerm_virtual_network.default.id
  resource_group_name   = var.resource_group_name
}