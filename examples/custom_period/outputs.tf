output "budget_id" {
  description = "The ID of the created budget."
  value       = module.custom_period_budget.id
}

output "budget_name" {
  description = "The display name of the created budget."
  value       = module.custom_period_budget.name
}
