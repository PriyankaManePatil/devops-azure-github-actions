# Security model

## Controls demonstrated

- OIDC instead of a stored Azure client secret
- Least-privilege GitHub workflow permissions
- Manual deployment trigger
- Explicit deployment enable variable
- What-If before deployment
- Environment-specific configuration and optional approval
- HTTPS/TLS controls and identity-first Storage authentication
- Dependabot monitoring for GitHub Actions

## Variables versus secrets

Client ID, tenant ID, subscription ID, and resource-group names are identifiers, not passwords. Variables are appropriate in this reference. Passwords, client secrets, connection strings, keys, and tokens must use an approved secret store and must never be committed.

## Trust boundaries

GitHub controls repository code, workflow execution, and the OIDC token request. Entra controls token exchange. Azure RBAC controls permitted operations. GitHub Environment rules control who may enter an environment. A secure design needs all four boundaries configured correctly.

## Supply-chain considerations

Major-version references such as `actions/checkout@v4` are readable and maintainable for this learning repository. Higher-assurance environments may pin actions to full immutable commit SHAs, document the trusted SHA, and use Dependabot or a controlled update process.

## Production hardening checklist

- Protect `main` and require successful validation.
- Require pull-request review and prevent force pushes.
- Add required reviewers to production.
- Restrict federated subjects to exact repository environments.
- Assign identities at the smallest Azure scope.
- Consider separate identities/subscriptions per environment.
- Pin third-party actions where policy requires.
- Add private endpoints, firewall rules, and private DNS where justified.
- Add diagnostics, threat protection, Policy, budgets, locks, and ownership tags.
- Retain deployment evidence and define incident/rollback procedures.

## Threat examples

| Threat | Mitigation |
|---|---|
| Secret copied from repository | No Azure client secret is stored |
| Accidental deployment | Manual trigger, enable flag, What-If, operation choice |
| Excessive cloud access | Resource-group-scoped RBAC |
| Malicious workflow change | PR review and branch protection |
| Dependency compromise | Review/pin actions and monitor updates |
| Anonymous data access | Public Blob access disabled |

