locals {
  # Role names are unique per tenant, so a name-derived GUID is stable and
  # known at plan time (unlike the provider-generated one).
  role_definition_guids = { for k, v in var.role_definitions : k => uuidv5("url", "azure-custom-role/${v.name}") }
}

resource "azurerm_role_definition" "this" {
  for_each = var.role_definitions

  role_definition_id = local.role_definition_guids[each.key]
  name               = each.value.name
  description        = each.value.description
  scope              = each.value.scope
  assignable_scopes  = coalesce(each.value.assignable_scopes, [each.value.scope])

  permissions {
    actions          = each.value.actions
    not_actions      = each.value.not_actions
    data_actions     = each.value.data_actions
    not_data_actions = each.value.not_data_actions
  }
}
