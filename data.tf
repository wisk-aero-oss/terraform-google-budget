### Get Billing Account
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/billing_account
data "google_billing_account" "self" {
  billing_account = var.billing_account
  display_name    = var.billing_name
  lookup_projects = false

  lifecycle {
    # Billing Account Selection
    precondition {
      condition     = !(var.billing_account == null && var.billing_name == null)
      error_message = "billing_account or billing_name must be set"
    }
    precondition {
      condition     = !(var.billing_account != null && var.billing_name != null)
      error_message = "Only one of billing_account or billing_name can be set"
    }

    # Budget Amount Configuration
    precondition {
      condition     = var.use_last_period_amount || var.amount != null
      error_message = "Either amount must be set, or use_last_period_amount must be true."
    }
    precondition {
      condition     = !(var.use_last_period_amount && var.amount != null)
      error_message = "amount and use_last_period_amount are mutually exclusive."
    }

    # Custom Period Configuration
    precondition {
      condition     = var.calendar_period != "CUSTOM" || var.custom_period_start_date != null
      error_message = "custom_period_start_date is required when calendar_period is CUSTOM."
    }

    # Monitoring & Alerting Requirements (API Constraints)
    precondition {
      condition     = (var.monitoring_notification_channels != null || var.pubsub_topic != null) || (!var.disable_default_iam_recipients && !var.enable_project_level_recipients)
      error_message = "At least one of monitoring_notification_channels or pubsub_topic must be provided when disable_default_iam_recipients or enable_project_level_recipients is true."
    }

    # Monitoring Project Lookup Requirements
    precondition {
      condition = var.monitoring_project != null || (
        (var.monitoring_notification_channels == null || alltrue([for c in(var.monitoring_notification_channels != null ? var.monitoring_notification_channels : []) : can(regex("^projects/", c))])) &&
        (var.pubsub_topic == null || can(regex("^projects/", var.pubsub_topic)))
      )
      error_message = "monitoring_project must be set when providing short names for monitoring_notification_channels or pubsub_topic."
    }
  }
}

### Get Pub/Sub Topic
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/pubsub_topic
data "google_pubsub_topic" "self" {
  count   = local.should_lookup_pubsub_topic ? 1 : 0
  name    = var.pubsub_topic
  project = var.monitoring_project

  depends_on = [data.google_billing_account.self]
}

### Get Subaccounts
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/billing_account
data "google_billing_account" "subaccounts" {
  for_each     = local.subaccount_lookup_names
  display_name = each.value
  open         = true

  depends_on = [data.google_billing_account.self]
}

### Get notification channels
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/monitoring_notification_channel
data "google_monitoring_notification_channel" "self" {
  for_each     = local.notification_channel_lookup_names
  display_name = each.value
  project      = var.monitoring_project

  depends_on = [data.google_billing_account.self]
}

### Get Project Numbers
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project
data "google_project" "self" {
  for_each   = local.project_lookup_ids
  project_id = each.value

  depends_on = [data.google_billing_account.self]
}

locals {

  # Common GCP Service IDs mapping for easier readability
  # Full list: https://cloud.google.com/skus/sku-groups (the id under the service name, not the sku)
  common_services = {
    "Artifact Registry"       = "services/149C-F9EC-3994"
    "BigQuery"                = "services/24E6-581D-38E5"
    "Cloud DNS"               = "services/FA26-5236-B8B5"
    "Cloud Filestore"         = "services/D97E-AB26-5D95"
    "Cloud Logging"           = "services/5490-F7B7-8DF6"
    "Cloud Monitoring"        = "services/58CD-E7C3-72CA"
    "Cloud Pub/Sub"           = "services/A1E8-BE35-7EBC"
    "Cloud Run Functions"     = "services/29E7-DA93-CA13"
    "Cloud Run"               = "services/152E-C115-5142"
    "Cloud Spanner"           = "services/CC63-0873-48FD"
    "Cloud SQL"               = "services/9662-B51E-5089"
    "Cloud Storage"           = "services/95FF-2EF5-5EA1"
    "Compute Engine"          = "services/6F81-5844-456A"
    "Confidential Computing"  = "services/65DF-8A98-0834"
    "Duet AI"                 = "services/719A-983F-202D"
    "Gemini API"              = "services/AEFD-7695-64FA"
    "Kubernetes Engine"       = "services/CCD8-9BF1-090E"
    "Networking"              = "services/E505-1604-58F8"
    "Notebooks"               = "services/D73B-5EEA-8215"
    "Secret Manager"          = "services/EE82-7A5E-871C"
    "Security Command Center" = "services/FBF2-FC68-171A"
    "Support"                 = "services/2062-016F-44A2"
    "Vertex AI"               = "services/C7E2-9256-1C43"
    "VM Manager"              = "services/5E18-9A83-2867"
  }

  # Pre-merge services for efficient lookup
  all_services_map = merge(local.common_services, var.custom_services_map)

  # Intermediate stripped lists to avoid redundant replace calls in for expressions
  _stripped_subaccounts = [for a in(var.subaccounts != null ? var.subaccounts : []) : replace(a, "(?i)^billingAccounts/", "")]
  _stripped_projects    = [for p in(var.projects != null ? var.projects : []) : replace(p, "^projects/", "")]

  # Filter for human-readable names (non-hex IDs) used by data source
  subaccount_lookup_names = {
    for s in local._stripped_subaccounts : s => s
    if !can(regex("^(?i)[A-Z0-9]{6}-[A-Z0-9]{6}-[A-Z0-9]{6}$", s))
  }

  # Filter for non-numeric project IDs used by data source
  project_lookup_ids = {
    for id in local._stripped_projects : id => id
    if length(regexall("^[0-9]+$", id)) == 0
  }

  # Filter for display names (non-resource IDs) used by data source
  notification_channel_lookup_names = {
    for c in(var.monitoring_notification_channels != null ? var.monitoring_notification_channels : []) : c => c
    if !can(regex("^projects/", c))
  }

  # Boolean flag to determine if we should look up a Pub/Sub topic short name
  should_lookup_pubsub_topic = var.pubsub_topic != null && !can(regex("^projects/", var.pubsub_topic))

  # Create a map of project_id -> project_number for all requested projects
  projects = { for p in data.google_project.self : p.project_id => p.number }

  # Resolve Subaccounts (Full Resource IDs)
  resolved_subaccounts = var.subaccounts == null ? null : toset([
    for s in local._stripped_subaccounts :
    s != "" && can(regex("^(?i)[A-Z0-9]{6}-[A-Z0-9]{6}-[A-Z0-9]{6}$", s)) ?
    "billingAccounts/${s}" : data.google_billing_account.subaccounts[s].name
  ])

  # Resolve Projects (Full Resource IDs)
  resolved_projects = var.projects == null ? null : toset([
    for id in local._stripped_projects :
    id != "" && length(regexall("^[0-9]+$", id)) > 0 ?
    "projects/${id}" : "projects/${lookup(local.projects, id, id)}"
  ])

  # Resolve Services (Service Resource IDs)
  resolved_services = var.services == null ? null : toset([
    for s in var.services : lookup(local.all_services_map, s, s)
  ])

  # Resolve Notification Channels (Full Resource IDs)
  resolved_notification_channels = var.monitoring_notification_channels == null ? null : toset([
    for channel in var.monitoring_notification_channels :
    can(regex("^projects/", channel)) ? channel : data.google_monitoring_notification_channel.self[channel].name
  ])

  # Resolve Pub/Sub Topic (Full Resource ID)
  resolved_pubsub_topic = var.pubsub_topic == null ? null : (
    can(regex("^projects/", var.pubsub_topic)) ? var.pubsub_topic : data.google_pubsub_topic.self[0].id
  )
}
