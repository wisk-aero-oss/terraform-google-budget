variable "billing_account_id" {
  description = "The ID of the billing account to use for the test budget."
  type        = string
  default     = "000000-000000-000000"
}

variable "subaccount_name" {
  description = "The human-readable display name of the sub-billing account."
  type        = string
  default     = "My Team Subaccount"
}

variable "project_id" {
  description = "The ID of the project where monitoring notification channels are defined."
  type        = string
  default     = "test-project-123"
}

variable "notification_channel" {
  description = "The display name of the monitoring notification channel."
  type        = string
  default     = "Admin Email"
}
