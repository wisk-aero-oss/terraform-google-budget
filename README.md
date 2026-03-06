
<!-- BEGIN_TF_DOCS -->
# GCP Billing Budget

[![Releases](https://img.shields.io/github/v/release/wisk-aero-oss/terraform-google-budget)](https://github.com/wisk-aero-oss/terraform-google-budget/releases)

[Terraform Module Registry](https://registry.terraform.io/modules/wisk-aero-oss/budget/google)

This module simplifies the creation and management of Google Cloud Billing Budgets.
It provides several quality-of-life enhancements over the raw `google_billing_budget` resource,
designed for ease-of-use in large-scale GCP organizations.

## Features

- **Human-Readable Project IDs:** Pass Project IDs (e.g. `your-project`) instead of cryptographical Project Numbers.
- **Common Service Aliases:** Use simple names like `BigQuery` or `Compute Engine` instead of hex Service IDs.
- **Extensible Service Aliases:** Add additional Service Aliases using the `custom_services_map`.
- **Notification Channel Lookups:** Link alerts using channel Display Names rather than unreadable resource IDs.
- **Pub/Sub Topic Lookups:** Link Pub/Sub alert topics using short names instead of full resource paths.
- **Human-Readable Subaccounts:** Filter by Billing Subaccount Display Names without needing their hex IDs.

## Usage

Basic usage of this module is as follows:

```hcl
module "example" {
    source  = "wisk-aero-oss/budget/google"
    version = "~> 0.1"

    # Identify the Billing Account (Required - choose one)
    billing_account = "000000-000000-000000"
    # billing_name  = "My Billing Account"

    # Budget Amount (Required - choose one)
    amount = "1000"
    # use_last_period_amount = true
    # Required variables
    name = 
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 7.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_billing_budget.budget](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_budget) | resource |
| [google_billing_account.self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/billing_account) | data source |
| [google_billing_account.subaccounts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/billing_account) | data source |
| [google_monitoring_notification_channel.self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/monitoring_notification_channel) | data source |
| [google_project.self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |
| [google_pubsub_topic.self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/pubsub_topic) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amount"></a> [amount](#input\_amount) | The budgeted amount for each usage period (in Currency/units). Only required if use\_last\_period\_amount is false. | `string` | `null` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | ID of the billing account to set a budget on. | `string` | `null` | no |
| <a name="input_billing_name"></a> [billing\_name](#input\_billing\_name) | Name of the billing account to set a budget on. Only one of billing\_account or billing\_name can be set. | `string` | `null` | no |
| <a name="input_calendar_period"></a> [calendar\_period](#input\_calendar\_period) | The period of time for which the budget applies. Possible values are MONTH, QUARTER, YEAR, and CUSTOM. | `string` | `null` | no |
| <a name="input_credit_types"></a> [credit\_types](#input\_credit\_types) | A list of credit types to include in the budget (e.g., 'COMMITTED\_USAGE\_DISCOUNT\_DOLLAR\_BASE'). Requires var.credit\_types\_treatment to be set to 'INCLUDE\_SPECIFIED\_CREDITS'. | `set(string)` | `null` | no |
| <a name="input_credit_types_treatment"></a> [credit\_types\_treatment](#input\_credit\_types\_treatment) | Specifies how credits should be treated when determining spend for threshold calculations. Possible values are INCLUDE\_ALL\_CREDITS, EXCLUDE\_ALL\_CREDITS, and INCLUDE\_SPECIFIED\_CREDITS. | `string` | `"INCLUDE_ALL_CREDITS"` | no |
| <a name="input_currency_code"></a> [currency\_code](#input\_currency\_code) | The 3-letter currency code defined in ISO 4217 (e.g., 'USD', 'EUR', 'GBP'). | `string` | `"USD"` | no |
| <a name="input_custom_period_end_date"></a> [custom\_period\_end\_date](#input\_custom\_period\_end\_date) | The end date of a custom budget period. | <pre>object({<br/>    year  = number<br/>    month = number<br/>    day   = number<br/>  })</pre> | `null` | no |
| <a name="input_custom_period_start_date"></a> [custom\_period\_start\_date](#input\_custom\_period\_start\_date) | The start date of a custom budget period. | <pre>object({<br/>    year  = number<br/>    month = number<br/>    day   = number<br/>  })</pre> | `null` | no |
| <a name="input_custom_services_map"></a> [custom\_services\_map](#input\_custom\_services\_map) | An optional map of human-readable service aliases to their GCP Service IDs. This is merged with the module's built-in map, allowing you to add niche services or override the default IDs. | `map(string)` | `{}` | no |
| <a name="input_disable_default_iam_recipients"></a> [disable\_default\_iam\_recipients](#input\_disable\_default\_iam\_recipients) | When set to true, disables default notifications sent to Billing Account Administrators when a threshold is exceeded. | `bool` | `false` | no |
| <a name="input_enable_project_level_recipients"></a> [enable\_project\_level\_recipients](#input\_enable\_project\_level\_recipients) | When set to true, enables project-level recipients to receive budget alerts. | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to filter the budget by. Only costs associated with resources with these labels will be included. | `map(string)` | `null` | no |
| <a name="input_monitoring_notification_channels"></a> [monitoring\_notification\_channels](#input\_monitoring\_notification\_channels) | A list of display names of monitoring notification channels to send alerts to. | `set(string)` | `null` | no |
| <a name="input_monitoring_project"></a> [monitoring\_project](#input\_monitoring\_project) | The project ID where the monitoring notification channels are defined. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the budget that will be displayed in the GCP console. Must be <= 60 chars | `string` | n/a | yes |
| <a name="input_projects"></a> [projects](#input\_projects) | A list of project IDs to include in the budget. If omitted, the budget applies to the entire billing account. | `set(string)` | `null` | no |
| <a name="input_pubsub_topic"></a> [pubsub\_topic](#input\_pubsub\_topic) | The Pub/Sub topic to send budget alerts to. Supports full resource IDs (projects/PRJ/topics/TOP) or short names (TOP) if monitoring\_project is set. | `string` | `null` | no |
| <a name="input_resource_ancestors"></a> [resource\_ancestors](#input\_resource\_ancestors) | A list of resource ancestors (e.g., 'organizations/12345678' or 'folders/87654321') to include in the budget. | `set(string)` | `null` | no |
| <a name="input_services"></a> [services](#input\_services) | A list of service IDs to include in the budget. Supports human-readable aliases like 'BigQuery', 'Compute Engine', and 'Cloud Storage' (see data.tf for the full list of supported aliases). If omitted, includes all services. | `set(string)` | `null` | no |
| <a name="input_subaccounts"></a> [subaccounts](#input\_subaccounts) | A list of sub-billing accounts to include in the budget. | `set(string)` | `null` | no |
| <a name="input_threshold_rules"></a> [threshold\_rules](#input\_threshold\_rules) | Rules that trigger alerts (notifications of thresholds being crossed) when spend exceeds the specified percentages of the budget. spend\_basis can be either 'CURRENT\_SPEND' or 'FORECASTED\_SPEND'. | <pre>list(object({<br/>    threshold_percent = number<br/>    spend_basis       = optional(string, "CURRENT_SPEND")<br/>  }))</pre> | <pre>[<br/>  {<br/>    "threshold_percent": 0.5<br/>  },<br/>  {<br/>    "threshold_percent": 0.9<br/>  },<br/>  {<br/>    "threshold_percent": 1<br/>  }<br/>]</pre> | no |
| <a name="input_use_last_period_amount"></a> [use\_last\_period\_amount](#input\_use\_last\_period\_amount) | When set to true, uses the amount of the last usage period as the budget amount. Mutually exclusive with var.amount. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created budget. |
| <a name="output_name"></a> [name](#output\_name) | The display name of the created budget. |

<!-- END_TF_DOCS -->
