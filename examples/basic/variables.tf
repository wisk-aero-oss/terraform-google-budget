variable "billing_account_id" {
  description = "The ID of the billing account to use for the test budget."
  type        = string
  default     = "000000-000000-000000"
}

variable "project_id" {
  description = "The GCP Project ID to use for testing."
  type        = string
  default     = "my-project-id"
}

variable "notification_channel" {
  description = "The display name of the notification channel to test linking."
  type        = string
  default     = "Test Channel"
}

variable "custom_services_map" {
  description = "An optional map of human-readable service aliases to their GCP Service IDs for testing."
  type        = map(string)
  default     = {}
}
