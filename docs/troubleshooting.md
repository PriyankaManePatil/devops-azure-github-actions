# Troubleshooting

## Workflow does not appear

Confirm the YAML is committed under `.github/workflows`, has `.yml`/`.yaml` extension, contains a supported trigger, and is present on the relevant branch.

## Validation fails

| Failure | Resolution |
|---|---|
| `az: command not found` locally | Install Azure CLI |
| Bicep command unavailable | Run `az bicep install` or `az bicep upgrade` |
| Template build error | Read file/line diagnostics; check braces, types, decorators |
| Parameter build error | Confirm parameter name/type and `using` path |
| No parameter files | Restore at least one `.bicepparam` file |
| PowerShell script blocked | Use PowerShell 7 and follow your organization's execution policy |

## Deployment job is skipped

`ENABLE_AZURE_DEPLOYMENT` must be exactly `true` in the repository or selected GitHub Environment. A missing value intentionally runs the guidance-only job.

## Azure Login fails

Verify client, tenant, and subscription IDs; federated issuer/audience/subject; exact environment name; `id-token: write`; role assignment; and Entra propagation time. Never “fix” this design by committing a client secret.

## Resource group verification fails

Confirm the selected environment maps to the correct variable, the resource group exists in the configured subscription, and the identity can read it.

## Azure validation or What-If fails

Check provider registration, region availability, Azure Policy, RBAC, naming requirements, quotas, API-version support, and whether the active subscription/tenant is correct.

## What-If shows deletion

Stop. Confirm the subscription, resource group, parameter file, template scope, and whether resources were renamed or removed. Do not deploy until every deletion is understood.

## Storage access fails after deployment

Shared-key access is intentionally disabled. Use Entra ID and an appropriate data-plane role. Management-plane Contributor does not automatically grant Blob data access.

## Diagnostic commands

```bash
az version
az bicep version
az account show
az group show --name "<resource-group>"
az role assignment list --assignee "<client-id>" --all
```

