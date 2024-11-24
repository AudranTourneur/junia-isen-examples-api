output "private_dns_zone_id" {
    description = "The ID of the private DNS zone"
    value       = azurerm_private_dns_zone.default.id
}

output "delegated_subnet_id" {
    description = "The ID of the delegated subnet"
    value       = azurerm_subnet.database.id
}