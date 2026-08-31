# Learning guide

| Stage | Azure login | Changes resources | Purpose |
|---|---:|---:|---|
| Bicep lint/build | No | No | Syntax, type, and style checks |
| Azure validate | Yes | No | Target-scope validation |
| Azure What-If | Yes | No | Predict additions, changes, deletions |
| Azure deployment | Yes | Yes | Apply reviewed desired state |

The workflow requests `id-token: write`; Azure Login exchanges the short-lived GitHub OIDC token through Entra ID. A matching federated credential and Azure role assignment must exist.

Exercises: add allowed regions, extract a Bicep module, add diagnostics, configure a dev What-If, add prod reviewers, compare identity scopes, and pin actions to immutable SHAs.

Common failures include a missing enable variable, incorrect federated subject/audience, wrong subscription, missing resource group, Policy restrictions, or parameter/template mismatch.

