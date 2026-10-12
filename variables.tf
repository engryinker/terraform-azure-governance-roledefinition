variable "role_definitions" {
  description = "Map of custom role definitions to create, keyed by an arbitrary caller-chosen map key. `scope` is where the definition lives (usually a management group ID); `assignable_scopes` defaults to `[scope]`. The role's GUID is derived deterministically from `name`, so `scopeless_ids` is known at plan time and can feed role assignments in the same run."
  type = map(object({
    name              = string
    description       = optional(string)
    scope             = string
    assignable_scopes = optional(list(string))
    actions           = optional(list(string), [])
    not_actions       = optional(list(string), [])
    data_actions      = optional(list(string), [])
    not_data_actions  = optional(list(string), [])
  }))
  default = {}

  validation {
    condition     = length(distinct([for v in var.role_definitions : v.name])) == length(var.role_definitions)
    error_message = "Role definition names must be unique (they are unique per tenant in Azure)."
  }
}
