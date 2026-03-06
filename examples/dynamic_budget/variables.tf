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

variable "pubsub_topic_name" {
  description = "The short name of the Pub/Sub topic to send budget alerts to."
  type        = string
  default     = "budget-alerts-topic"
}

variable "notification_channel_name" {
  description = "The display name of the notification channel to test linking."
  type        = string
  default     = "Slack Alerts Channel"
}
