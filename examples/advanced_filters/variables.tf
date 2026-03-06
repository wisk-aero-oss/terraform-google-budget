variable "billing_account_id" {
  description = "The ID of the billing account to use for the test budget."
  type        = string
  default     = "000000-000000-000000"
}

variable "subaccount_id" {
  description = "The ID of the sub-billing account to use for testing."
  type        = string
  default     = "111111-222222-333333"
}
