# Azure DevOps with GitHub Actions and Bicep

Education-first reference for secure Azure infrastructure CI/CD using GitHub Actions, Bicep, OIDC, Azure What-If, and environment-aware deployment.

> Start here if you are new: [Fundamentals](docs/fundamentals.md) → [Getting started](docs/getting-started.md) → [Architecture](docs/architecture.md).

## Safety and purpose

This repository is for learning, interviews, and architecture discussions. It does not create credentials, subscriptions, resource groups, approvals, or live resources automatically. Azure operations are guarded by the repository variable `ENABLE_AZURE_DEPLOYMENT=true`; otherwise the deployment workflow only displays guidance.

It demonstrates credential-free Bicep validation, environment parameter files, manual What-If/deploy selection, passwordless OIDC authentication, GitHub Environments, and secure Azure Storage defaults.

## What you will learn

1. Why Infrastructure as Code is preferable to repeated portal changes.
2. How GitHub discovers and executes workflows.
3. How Bicep templates, parameters, variables, resources, and outputs work.
4. How CI validates infrastructure without Azure credentials.
5. How OIDC provides passwordless GitHub-to-Azure authentication.
6. How Validate, What-If, and Deploy differ.
7. How environment configuration and approvals reduce deployment risk.

## Structure

```text
.github/workflows/     Validation and guarded deployment
infra/                 Template and dev/test/prod parameters
scripts/deploy.ps1     Local validation, What-If, deployment
docs/                  Architecture and learning notes
```

## Documentation map

| Guide | Question answered |
|---|---|
| [Fundamentals](docs/fundamentals.md) | What are IaC, Bicep, CI/CD, runners, OIDC, and What-If? |
| [Getting started](docs/getting-started.md) | How do I learn, validate locally, or run an optional lab? |
| [Architecture](docs/architecture.md) | How do components and trust boundaries connect? |
| [Workflows explained](docs/workflows-explained.md) | What does each important YAML section do and why? |
| [Bicep explained](docs/bicep-explained.md) | How and why is the template designed this way? |
| [OIDC setup](docs/oidc-setup.md) | How does passwordless Azure authentication work? |
| [Security](docs/security.md) | Which risks and controls should I understand? |
| [Troubleshooting](docs/troubleshooting.md) | How do I diagnose common failures safely? |
| [Production readiness](docs/production-readiness.md) | What is deliberately excluded from this reference? |
| [Interview guide](docs/interview-guide.md) | How can I explain and defend the design? |
| [Glossary](docs/glossary.md) | What do unfamiliar terms mean? |
| [FAQ](docs/faq.md) | What are the common beginner questions? |

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

## Validation evidence

The repository validation workflow performs Bicep linting and compiles the template plus every `.bicepparam` file. A green run proves the committed reference files compile; it does not claim that an arbitrary Azure subscription will authorize or accept a live deployment.

## Reference limitations

This is not an enterprise landing zone or application delivery system. See [Production readiness](docs/production-readiness.md) before adapting it.

Licensed under the MIT License.
