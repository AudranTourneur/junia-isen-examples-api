output "fqdn" {
    description = "The FQDN (Fully Qualified Domain Name) of the Postgres database"
    value = azurerm_postgresql_flexible_server.main.fqdn
}
