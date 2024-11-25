output "private_dns_zone_id" {
  description = "The ID of the private DNS zone"
  value       = azurerm_private_dns_zone.default.id
}

output "virtual_network_name" {
  description = "The name of the virtual netowrk"
  value       = azurerm_virtual_network.default.name
}

output "network_security_group_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.default.id
}

output "private_dns_zone_name" {
  description = "The name of the Private DNS Zone"
  value       = azurerm_private_dns_zone.default.name
}
