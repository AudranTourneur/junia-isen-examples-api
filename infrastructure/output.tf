output "url" {
  description = "The deployed URL of the application"
  value       = module.app.url
}

output "app_name" {
  description = "App name"
  value       = module.app.name
}
