# terraform-azure-governance-roledefinition

Org-standard Terraform wrapper for **custom Azure RBAC role definitions**.

⚠️ **No AVM module exists for this resource** as of this writing. This wraps the native `azurerm_role_definition` resource directly, following the same conventions as the rest of this org's module set. Swap it for an AVM module if/when Microsoft publishes one.

Role definitions have no resource group, location or tags, so this module has none of the standard `resource_group_name` / `location` / `tags` / `enable_telemetry` inputs. Each role's GUID is derived from its name (`uuidv5`), so `scopeless_ids` is known at plan time. That lets you assign a role in the same run that creates it, e.g. via `terraform-azure-governance-subscription`'s `role_assignments`.

## Usage

```hcl
module "governance-roledefinition" {
  source = "git::https://github.com/engryinker/terraform-azure-governance-roledefinition.git?ref=v1.0.0"

  role_definitions = {
    lz_contributor = {
      name        = "Contoso Landing Zone Contributor"
      description = "Contributor without network write"
      scope       = module.governance-managementgroup.management_group_ids["org"]
      actions     = ["*"]
      not_actions = ["Microsoft.Authorization/*/Write", "Microsoft.Network/virtualNetworks/write"]
    }
  }
}
```

See [`examples/basic`](examples/basic) for a minimal runnable (zero-instance) example.

## Inputs

### `role_definitions`

| Field | Type | Required | Notes |
| --- | --- | --- | --- |
| `name` | `string` | yes | Unique per tenant. Also seeds the role GUID: renaming creates a new role. |
| `description` | `string` | no |  |
| `scope` | `string` | yes | Where the definition lives: a management group or subscription ID. |
| `assignable_scopes` | `list(string)` | no | Defaults to `[scope]`. |
| `actions` / `not_actions` | `list(string)` | no | Control-plane permissions. |
| `data_actions` / `not_data_actions` | `list(string)` | no | Data-plane permissions. |

The identity running Terraform needs `Microsoft.Authorization/roleDefinitions/write` at `scope` (e.g. *User Access Administrator* or *Owner*).

## Outputs

- `role_definitions` -- map (same keys as the input) of every attribute of each created role definition.
- `scopeless_ids` -- map (same keys as the input) of `/providers/Microsoft.Authorization/roleDefinitions/<guid>`, known at plan time.
