output "url" {
  description = "The deployed URL of the application"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "name" {
  description = "The name of the application"
  value       = azurerm_linux_web_app.main.name
}
