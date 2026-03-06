module "advanced_filters_budget" {
  source = "../.."

  name            = "advanced-filters-budget"
  billing_account = var.billing_account_id
  amount          = "5000"

  # Granular Filtering
  labels = {
    environment = "production"
    team        = "backend"
  }

  resource_ancestors = [
    "organizations/123456789012",
    "folders/987654321098"
  ]

  subaccounts = [
    var.subaccount_id
  ]

  # Credit Type Filtering
  credit_types_treatment = "INCLUDE_SPECIFIED_CREDITS"
  credit_types = [
    "COMMITTED_USAGE_DISCOUNT_DOLLAR_BASE",
    "DISCOUNT"
  ]

  # Specific Period
  calendar_period = "QUARTER"

  threshold_rules = [
    { threshold_percent = 0.5, spend_basis = "CURRENT_SPEND" },
    { threshold_percent = 0.9, spend_basis = "FORECASTED_SPEND" },
    { threshold_percent = 1.0, spend_basis = "CURRENT_SPEND" }
  ]
}
