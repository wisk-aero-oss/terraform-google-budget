module "test_budget" {
  source = "../.."

  name            = "example-budget"
  billing_account = var.billing_account_id
  amount          = "1000"

  projects = [var.project_id]

  # Testing custom mapping and built-in aliases together
  custom_services_map = var.custom_services_map
  services            = ["BigQuery", "Compute Engine", "Pub/Sub Lite"]

  threshold_rules = [
    { threshold_percent = 0.5, spend_basis = "CURRENT_SPEND" },
    { threshold_percent = 0.8, spend_basis = "FORECASTED_SPEND" },
    { threshold_percent = 1.0, spend_basis = "CURRENT_SPEND" }
  ]

  # Linking an existing notification channel
  monitoring_project               = var.project_id
  monitoring_notification_channels = [var.notification_channel]
}
