# Getting started

## Learning-only path

No Azure account is required to read the project or inspect successful workflow runs.

1. Read `fundamentals.md`.
2. Read `architecture.md`.
3. Open `.github/workflows/bicep-validation.yml`.
4. Compare `infra/main.bicep` with the three parameter files.
5. Read `workflows-explained.md` and `bicep-explained.md`.
6. Fork the repository and change a non-secret tag.
7. Open a pull request and observe validation.

## Local validation path

Install Git, Azure CLI, its Bicep component, and PowerShell 7. Confirm:

```powershell
git --version
az version
az bicep version
pwsh --version
```

Run:

```powershell
./scripts/deploy.ps1 -Environment dev -Mode Validate
```

Expected result: lint/build operations succeed and the script confirms that no Azure operation occurred.

## Optional Azure lab path

1. Select a disposable or approved subscription.
2. Create dedicated resource groups for dev/test/prod.
3. Configure an Entra identity and federated credentials using `oidc-setup.md`.
4. Create matching GitHub Environments.
5. Add the documented variables—never secrets.
6. First run the workflow with `operation=what-if`.
7. Review the exact target and predicted changes.
8. Select `deploy` only for a deliberate lab.
9. Delete only the lab resources after learning.

Example resource-group creation:

```bash
az account set --subscription "<subscription-id>"
az group create --name rg-devops-reference-dev --location centralindia
```

Safe cleanup:

```bash
az group delete --name rg-devops-reference-dev --yes --no-wait
```

Never copy that cleanup command against a shared or pre-existing resource group.

## Expected repository variables

| Name | Scope | Example |
|---|---|---|
| `ENABLE_AZURE_DEPLOYMENT` | Repository or Environment | `true` |
| `AZURE_CLIENT_ID` | Repository or Environment | Entra application client ID |
| `AZURE_TENANT_ID` | Repository or Environment | Tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Repository or Environment | Subscription ID |
| `AZURE_RESOURCE_GROUP_DEV` | Repository | `rg-devops-reference-dev` |
| `AZURE_RESOURCE_GROUP_TEST` | Repository | `rg-devops-reference-test` |
| `AZURE_RESOURCE_GROUP_PROD` | Repository | `rg-devops-reference-prod` |

