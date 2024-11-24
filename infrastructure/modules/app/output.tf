output "url" {
  description = "The deployed URL of the application"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "publish_profile_name" {
    description = "Publish profile name"
    value = azurerm_linux_web_app.main.site_credential[0].name
    sensitive = true
}

output "publish_profile_password" {
    description = "Publish profile password"
    value = azurerm_linux_web_app.main.site_credential[0].password
    sensitive = true
}

output "name" {
  value = azurerm_linux_web_app.main.name
}
