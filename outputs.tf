output "id" {
  description = "The ID of the created budget."
  value       = google_billing_budget.budget.name
}

output "name" {
  description = "The display name of the created budget."
  value       = google_billing_budget.budget.display_name
}
