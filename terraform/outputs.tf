output "frontend_url" {
  value = "https://${azurerm_linux_web_app.fe-webapp.default_hostname}"
}

output "backend_url" {
  value = "https://${azurerm_linux_function_app.be-arapp.default_hostname}"
}

output "instrumentation_key" {
  value     = azurerm_application_insights.ar-appinsights.instrumentation_key
  sensitive = true
}

output "app_id" {
  value     = azurerm_application_insights.ar-appinsights.app_id
  sensitive = true
}
