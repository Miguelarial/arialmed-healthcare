variable "location" {
  description = "Location for all resources"
  default     = "East US"
}

variable "app_name" {
  description = "Base name for app"
  default     = "arialmed"
}

variable "resource_group_name" {
  description = "Name for the resource group"
  default     = "arialmed-resources"
}

# Arialmed-related variables
variable "PROJECT_ID" {
  description = "Appwrite Project ID"
}

variable "API_KEY" {
  description = "Appwrite API Key"
}

variable "DATABASE_ID" {
  description = "Appwrite Database ID"
}

variable "PATIENT_COLLECTION_ID" {
  description = "Appwrite Patient Collection ID"
}

variable "DOCTOR_COLLECTION_ID" {
  description = "Appwrite Doctor Collection ID"
}

variable "APPOINTMENT_COLLECTION_ID" {
  description = "Appwrite Appointment Collection ID"
}

variable "BUCKET_ID" {
  description = "Appwrite Bucket ID"
}

variable "API_ENDPOINT" {
  description = "Appwrite API Endpoint"
}

variable "ADMIN_PASSKEY" {
  description = "Admin Passkey"
}

variable "SERVICE_ID" {
  description = "Email Service ID"
}

variable "TEMPLATE_ID" {
  description = "Email Template ID"
}

variable "EMAIL_API_KEY" {
  description = "Email API Key"
}

variable "SENTRY_AUTH_TOKEN" {
  description = "Sentry Auth Token"
}
