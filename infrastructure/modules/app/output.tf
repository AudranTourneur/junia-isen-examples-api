output "url" {
  description = "The deployed URL of the application"
  value       = azurerm_linux_web_app.main.default_hostname
}