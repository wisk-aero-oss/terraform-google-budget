/**
 * # GCP Billing Budget
 *
 * [![Releases](https://img.shields.io/github/v/release/wisk-aero-oss/terraform-google-budget)](https://github.com/wisk-aero-oss/terraform-google-budget/releases)
 *
 * [Terraform Module Registry](https://registry.terraform.io/modules/wisk-aero-oss/budget/google)
 *
 * This module simplifies the creation and management of Google Cloud Billing Budgets.
 * It provides several quality-of-life enhancements over the raw `google_billing_budget` resource,
 * designed for ease-of-use in large-scale GCP organizations.
 *
 * ## Features
 *
 * - **Human-Readable Project IDs:** Pass Project IDs (e.g. `your-project`) instead of cryptographical Project Numbers.
 * - **Common Service Aliases:** Use simple names like `BigQuery` or `Compute Engine` instead of hex Service IDs.
 * - **Extensible Service Aliases:** Add additional Service Aliases using the `custom_services_map`.
 * - **Notification Channel Lookups:** Link alerts using channel Display Names rather than unreadable resource IDs.
 * - **Pub/Sub Topic Lookups:** Link Pub/Sub alert topics using short names instead of full resource paths.
 * - **Human-Readable Subaccounts:** Filter by Billing Subaccount Display Names without needing their hex IDs.
 *
 */

## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_budget
resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.self.id
  display_name    = var.name

  budget_filter {
    projects               = local.resolved_projects
    resource_ancestors     = var.resource_ancestors
    subaccounts            = local.resolved_subaccounts
    credit_types           = var.credit_types
    credit_types_treatment = var.credit_types_treatment
    services               = local.resolved_services
    labels                 = var.labels

    calendar_period = var.calendar_period == "CUSTOM" ? null : var.calendar_period

    dynamic "custom_period" {
      for_each = var.calendar_period == "CUSTOM" ? [1] : []
      content {
        start_date {
          year  = var.custom_period_start_date.year
          month = var.custom_period_start_date.month
          day   = var.custom_period_start_date.day
        }
        dynamic "end_date" {
          for_each = var.custom_period_end_date != null ? [1] : []
          content {
            year  = var.custom_period_end_date.year
            month = var.custom_period_end_date.month
            day   = var.custom_period_end_date.day
          }
        }
      }
    }
  }

  amount {
    dynamic "specified_amount" {
      for_each = var.use_last_period_amount ? [] : [1]
      content {
        currency_code = var.currency_code
        units         = var.amount
      }
    }
    last_period_amount = var.use_last_period_amount ? true : null
  }

  dynamic "threshold_rules" {
    for_each = var.threshold_rules != null ? var.threshold_rules : []

    content {
      threshold_percent = threshold_rules.value.threshold_percent
      spend_basis       = threshold_rules.value.spend_basis
    }
  }

  dynamic "all_updates_rule" {
    for_each = (var.monitoring_notification_channels != null || var.pubsub_topic != null || var.disable_default_iam_recipients || var.enable_project_level_recipients) ? [1] : []

    content {
      monitoring_notification_channels = local.resolved_notification_channels
      pubsub_topic                     = local.resolved_pubsub_topic
      disable_default_iam_recipients   = var.disable_default_iam_recipients
      enable_project_level_recipients  = var.enable_project_level_recipients
    }
  }

  lifecycle {
    precondition {
      condition     = (var.monitoring_notification_channels != null || var.pubsub_topic != null) || (!var.disable_default_iam_recipients && !var.enable_project_level_recipients)
      error_message = "At least one of monitoring_notification_channels or pubsub_topic must be provided when disable_default_iam_recipients or enable_project_level_recipients is true."
    }
  }
}
