variable "billing_account" {
  description = "ID of the billing account to set a budget on."
  type        = string
  default     = null
}

variable "billing_name" {
  description = "Name of the billing account to set a budget on. Only one of billing_account or billing_name can be set."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the budget that will be displayed in the GCP console. Must be <= 60 chars"
  type        = string

  validation {
    condition     = length(var.name) <= 60
    error_message = "The budget name must be 60 characters or fewer."
  }
}

variable "amount" {
  description = "The budgeted amount for each usage period (in Currency/units). Only required if use_last_period_amount is false."
  type        = string
  default     = null
}

variable "use_last_period_amount" {
  description = "When set to true, uses the amount of the last usage period as the budget amount. Mutually exclusive with var.amount."
  type        = bool
  default     = false
}

variable "currency_code" {
  description = "The 3-letter currency code defined in ISO 4217 (e.g., 'USD', 'EUR', 'GBP')."
  type        = string
  default     = "USD"
}

variable "projects" {
  description = "A list of project IDs to include in the budget. If omitted, the budget applies to the entire billing account."
  type        = set(string)
  default     = null
}

variable "resource_ancestors" {
  description = "A list of resource ancestors (e.g., 'organizations/12345678' or 'folders/87654321') to include in the budget."
  type        = set(string)
  default     = null
}

variable "subaccounts" {
  description = "A list of sub-billing accounts to include in the budget."
  type        = set(string)
  default     = null
}

variable "labels" {
  description = "A map of labels to filter the budget by. Only costs associated with resources with these labels will be included."
  type        = map(string)
  default     = null
}

variable "services" {
  description = "A list of service IDs to include in the budget. Supports human-readable aliases like 'BigQuery', 'Compute Engine', and 'Cloud Storage' (see data.tf for the full list of supported aliases). If omitted, includes all services."
  type        = set(string)
  default     = null
}

variable "custom_services_map" {
  description = "An optional map of human-readable service aliases to their GCP Service IDs. This is merged with the module's built-in map, allowing you to add niche services or override the default IDs."
  type        = map(string)
  default     = {}
}

variable "credit_types" {
  description = "A list of credit types to include in the budget (e.g., 'COMMITTED_USAGE_DISCOUNT_DOLLAR_BASE'). Requires var.credit_types_treatment to be set to 'INCLUDE_SPECIFIED_CREDITS'."
  type        = set(string)
  default     = null
}

variable "credit_types_treatment" {
  description = "Specifies how credits should be treated when determining spend for threshold calculations. Possible values are INCLUDE_ALL_CREDITS, EXCLUDE_ALL_CREDITS, and INCLUDE_SPECIFIED_CREDITS."
  type        = string
  default     = "INCLUDE_ALL_CREDITS"
}

variable "calendar_period" {
  description = "The period of time for which the budget applies. Possible values are MONTH, QUARTER, YEAR, and CUSTOM."
  type        = string
  default     = null
}

variable "custom_period_start_date" {
  description = "The start date of a custom budget period."
  type = object({
    year  = number
    month = number
    day   = number
  })
  default = null
}

variable "custom_period_end_date" {
  description = "The end date of a custom budget period."
  type = object({
    year  = number
    month = number
    day   = number
  })
  default = null
}

variable "threshold_rules" {
  description = "Rules that trigger alerts (notifications of thresholds being crossed) when spend exceeds the specified percentages of the budget. spend_basis can be either 'CURRENT_SPEND' or 'FORECASTED_SPEND'."
  type = list(object({
    threshold_percent = number
    spend_basis       = optional(string, "CURRENT_SPEND")
  }))
  default = [
    { threshold_percent = 0.5 },
    { threshold_percent = 0.9 },
    { threshold_percent = 1.0 }
  ]
}

variable "monitoring_notification_channels" {
  description = "A list of display names of monitoring notification channels to send alerts to."
  type        = set(string)
  default     = null
}

variable "monitoring_project" {
  description = "The project ID where the monitoring notification channels are defined."
  type        = string
  default     = null
}

variable "pubsub_topic" {
  description = "The Pub/Sub topic to send budget alerts to. Supports full resource IDs (projects/PRJ/topics/TOP) or short names (TOP) if monitoring_project is set."
  type        = string
  default     = null
}

variable "disable_default_iam_recipients" {
  description = "When set to true, disables default notifications sent to Billing Account Administrators when a threshold is exceeded."
  type        = bool
  default     = false
}

variable "enable_project_level_recipients" {
  description = "When set to true, enables project-level recipients to receive budget alerts."
  type        = bool
  default     = false
}
