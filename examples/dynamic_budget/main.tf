module "dynamic_budget" {
  source = "../.."

  name            = "dynamic-pubsub-budget"
  billing_account = var.billing_account_id

  # Dynamic Amount: Use Last Period's Spend
  use_last_period_amount = true
  # Note: 'amount' is omitted entirely

  # Projects to scope the budget
  projects = [var.project_id]

  threshold_rules = [
    { threshold_percent = 0.8 },
    { threshold_percent = 1.0 },
    { threshold_percent = 1.2, spend_basis = "FORECASTED_SPEND" }
  ]

  # Alerting Setup
  monitoring_project = var.project_id

  # 1. Human-readable Pub/Sub Topic
  pubsub_topic = var.pubsub_topic_name

  # 2. Project-level Recipients
  enable_project_level_recipients = true

  # 3. Mixing ID and Name for notification channels
  monitoring_notification_channels = [
    var.notification_channel_name,                                        # Short Name
    "projects/${var.project_id}/notificationChannels/1111111111111111111" # Full Resource ID
  ]
}
