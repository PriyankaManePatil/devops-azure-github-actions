# Learning guide

Use this page as a curriculum checklist. Follow the linked material in order.

## Beginner

1. [Fundamentals](fundamentals.md)
2. [Getting started](getting-started.md)
3. [Glossary](glossary.md)
4. [Architecture](architecture.md)

## Intermediate

1. [Workflows explained](workflows-explained.md)
2. [Bicep explained](bicep-explained.md)
3. [OIDC setup](oidc-setup.md)
4. [Security model](security.md)

## Advanced

1. [Production readiness](production-readiness.md)
2. [Troubleshooting](troubleshooting.md)
3. [Interview guide](interview-guide.md)
4. [FAQ](faq.md)

| Stage | Azure login | Changes resources | Purpose |
|---|---:|---:|---|
| Bicep lint/build | No | No | Syntax, type, and style checks |
| Azure validate | Yes | No | Target-scope validation |
| Azure What-If | Yes | No | Predict additions, changes, deletions |
| Azure deployment | Yes | Yes | Apply reviewed desired state |

The workflow requests `id-token: write`; Azure Login exchanges the short-lived GitHub OIDC token through Entra ID. A matching federated credential and Azure role assignment must exist.

## Exercises

- Change a non-secret tag and observe PR validation.
- Add an allowed region parameter.
- Extract Storage into a reusable Bicep module.
- Add diagnostic settings and explain their cost.
- Configure a dev What-If with resource-group-scoped identity.
- Add production required reviewers.
- Compare environment-based and branch-based federated subjects.
- Pin actions to immutable commit SHAs and document the update process.

Common failures include a missing enable variable, incorrect federated subject/audience, wrong subscription, missing resource group, Policy restrictions, or parameter/template mismatch.
