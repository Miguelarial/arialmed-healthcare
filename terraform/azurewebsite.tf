resource "azurerm_app_service_plan" "app_plan" {
  name                = "${var.app_name}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "frontend" {
  name                = "${var.app_name}-frontend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_plan.id

  site_config {
    linux_fx_version = "NODE|14-lts"
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "14-lts"
  }
}

resource "azurerm_function_app" "backend" {
  name                       = "${var.app_name}-backend"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.app_plan.id
  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key
  os_type                    = "linux"
  version                    = "~3"

  site_config {
    linux_fx_version = "Node|14"
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "node"
  }
}

resource "azurerm_storage_account" "function_storage" {
  name                     = "${var.app_name}funcstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "fe-asp" {
  name                = "fe-asp-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "fe-webapp" {
  name                  = "arialmed"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.fe-asp.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
    always_on           = true

    application_stack {
      node_version = "16-lts"
    }
  }
  
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.ar-appinsights.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"   = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
    "PROJECT_ID"                  = var.PROJECT_ID
    "API_KEY"                     = var.API_KEY
    "DATABASE_ID"                 = var.DATABASE_ID
    "NEXT_PUBLIC_BUCKET_ID"       = var.BUCKET_ID
    "NEXT_PUBLIC_ENDPOINT"        = var.API_ENDPOINT
    "NEXT_PUBLIC_ADMIN_PASSKEY"   = var.ADMIN_PASSKEY
    "NEXT_PUBLIC_SERVICEID"       = var.SERVICE_ID
    "NEXT_PUBLIC_TEMPLATEID"      = var.TEMPLATE_ID
    "NEXT_PUBLIC_APIKEY"          = var.EMAIL_API_KEY
    "SENTRY_AUTH_TOKEN"           = var.SENTRY_AUTH_TOKEN
  }

  depends_on = [
    azurerm_service_plan.fe-asp,
    azurerm_application_insights.ar-appinsights
  ]
}

resource "azurerm_service_plan" "be-asp" {
  name                = "be-asp-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_storage_account" "ar-storageaccount" {
  name                     = "arfunctionappsa2024"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_function_app" "be-arapp" {
  name                = "be-function-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.ar-storageaccount.name
  storage_account_access_key = azurerm_storage_account.ar-storageaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.be-asp.id
  
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.ar-appinsights.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"   = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
    "PROJECT_ID"                  = var.PROJECT_ID
    "API_KEY"                     = var.API_KEY
    "DATABASE_ID"                 = var.DATABASE_ID
    "PATIENT_COLLECTION_ID"       = var.PATIENT_COLLECTION_ID
    "DOCTOR_COLLECTION_ID"        = var.DOCTOR_COLLECTION_ID
    "APPOINTMENT_COLLECTION_ID"   = var.APPOINTMENT_COLLECTION_ID
    "NEXT_PUBLIC_BUCKET_ID"       = var.BUCKET_ID
    "NEXT_PUBLIC_ENDPOINT"        = var.API_ENDPOINT
    "NEXT_PUBLIC_ADMIN_PASSKEY"   = var.ADMIN_PASSKEY
    "NEXT_PUBLIC_SERVICEID"       = var.SERVICE_ID
    "NEXT_PUBLIC_TEMPLATEID"      = var.TEMPLATE_ID
    "NEXT_PUBLIC_APIKEY"          = var.EMAIL_API_KEY
    "SENTRY_AUTH_TOKEN"           = var.SENTRY_AUTH_TOKEN
  }

  site_config {
    application_stack {
      node_version = "16"
    }
  }

  depends_on = [
    azurerm_storage_account.ar-storageaccount
  ]
}
