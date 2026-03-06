output "budget_id" {
  description = "The ID of the created budget."
  value       = module.advanced_filters_budget.id
}

output "budget_name" {
  description = "The display name of the created budget."
  value       = module.advanced_filters_budget.name
}
