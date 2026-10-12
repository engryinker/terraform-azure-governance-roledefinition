output "role_definitions" {
  description = "Map (same keys as var.role_definitions) of every attribute of each role definition created."
  value       = azurerm_role_definition.this
}

output "scopeless_ids" {
  description = "Map (same keys as var.role_definitions) of scopeless role definition IDs (`/providers/Microsoft.Authorization/roleDefinitions/<guid>`) -- the form terraform-azure-governance-subscription's role assignments expect. Known at plan time."
  value       = { for k, guid in local.role_definition_guids : k => "/providers/Microsoft.Authorization/roleDefinitions/${guid}" }
}
