# Azure DevOps with GitHub Actions and Bicep

Education-first reference for secure Azure infrastructure CI/CD using GitHub Actions, Bicep, OIDC, Azure What-If, and environment-aware deployment.

## Safety and purpose

This repository is for learning, interviews, and architecture discussions. It does not create credentials, subscriptions, resource groups, approvals, or live resources automatically. Azure operations are guarded by the repository variable `ENABLE_AZURE_DEPLOYMENT=true`; otherwise the deployment workflow only displays guidance.

It demonstrates credential-free Bicep validation, environment parameter files, manual What-If/deploy selection, passwordless OIDC authentication, GitHub Environments, and secure Azure Storage defaults.

## Structure

```text
.github/workflows/     Validation and guarded deployment
infra/                 Template and dev/test/prod parameters
scripts/deploy.ps1     Local validation, What-If, deployment
docs/                  Architecture and learning notes
```

## Optional live-lab configuration

Create an Entra application or user-assigned identity, a federated credential trusting this repository/environment, a least-privilege role assignment, pre-created resource groups, and GitHub Environments named `dev`, `test`, and `prod`.

| Variable | Purpose |
|---|---|
| `ENABLE_AZURE_DEPLOYMENT` | Explicit opt-in; must equal `true` |
| `AZURE_CLIENT_ID` | Entra identity client ID |
| `AZURE_TENANT_ID` | Tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Target subscription |
| `AZURE_RESOURCE_GROUP_DEV/TEST/PROD` | Environment resource groups |

Do not commit secrets or credential JSON. Add required reviewers to the `prod` Environment when studying approvals.

## Local examples

```powershell
./scripts/deploy.ps1 -Environment dev -Mode Validate
./scripts/deploy.ps1 -Environment dev -Mode WhatIf -ResourceGroupName "<resource-group>"
./scripts/deploy.ps1 -Environment dev -Mode Deploy -ResourceGroupName "<resource-group>"
```

The template declares a uniquely named StorageV2 account with HTTPS, TLS 1.2, public Blob access disabled, shared-key authorization disabled, OAuth by default, infrastructure encryption, tags, and outputs. Real workloads should additionally assess private networking, diagnostics, Policy, Defender, retention, cost, and disaster recovery.

Read [the architecture](docs/architecture.md) and [learning guide](docs/learning-guide.md). Licensed under MIT.

