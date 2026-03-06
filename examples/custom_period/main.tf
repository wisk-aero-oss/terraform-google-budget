module "custom_period_budget" {
  source = "../.."

  name            = "custom-period-budget"
  billing_account = var.billing_account_id

  # Non-USD currency testing
  amount        = "1000"
  currency_code = "EUR"

  # Testing Human-Readable Subaccounts
  subaccounts = [
    var.subaccount_name
  ]

  # Testing Custom Budget Period
  calendar_period = "CUSTOM"
  custom_period_start_date = {
    year  = 2024
    month = 1
    day   = 1
  }
  custom_period_end_date = {
    year  = 2024
    month = 12
    day   = 31
  }

  # Disabling default IAM recipients requires an alternative notification channel
  monitoring_project               = var.project_id
  monitoring_notification_channels = [var.notification_channel]
  disable_default_iam_recipients   = true

  threshold_rules = [
    { threshold_percent = 0.5 }
  ]
}
