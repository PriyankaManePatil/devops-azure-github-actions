# Interview guide

## Explain the project in 60 seconds

This repository demonstrates an Azure IaC delivery pipeline. Pull requests and changes to main run credential-free Bicep lint/build validation. A separate manual workflow uses GitHub OIDC to authenticate without a client secret, selects environment configuration, validates against Azure, always runs What-If, and deploys only after two explicit safety gates. Bicep creates a securely configured Storage Account with environment-aware redundancy.

## Questions and model points

### Why separate validation and deployment workflows?

Validation is safe, fast, and credential-free, so it can run automatically. Deployment needs identity, environment controls, target configuration, and deliberate authorization.

### Why OIDC instead of a service-principal secret?

OIDC uses short-lived tokens and removes secret storage/rotation. Trust is constrained through issuer, audience, subject, RBAC scope, and environment.

### Why run What-If?

It previews additions, modifications, and deletions against the target scope. It improves review but does not replace testing, approval, or policy.

### Why use parameter files?

One template remains the source of truth while environment-specific non-secret values vary in typed, validated files.

### Why is public networking enabled?

To keep the teaching example independent of virtual networks and private DNS. A production workload must decide based on threat model and connectivity requirements.

### Why not create resource groups?

Using existing groups lets the deployment identity operate at smaller scope and keeps subscription-level provisioning outside the beginner example.

### What would you add next?

Modules, diagnostics, private connectivity, policy, security scanning, action SHA pinning, branch protection, deployment outputs/artifacts, integration tests, budgets, and recovery procedures.

