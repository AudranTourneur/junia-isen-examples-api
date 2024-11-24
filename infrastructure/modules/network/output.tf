output "private_dns_zone_id" {
    description = "The ID of the private DNS zone"
    value       = azurerm_private_dns_zone.default.id
}

output "virtual_network_name" {
    description = ""
    value = azurerm_virtual_network.default.name
}

output "network_security_group_id" {
    description = ""
    value = azurerm_network_security_group.default.id
}

output "private_dns_zone_name" {
    description = ""
    value = azurerm_private_dns_zone.default.name
}