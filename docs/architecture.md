# Architecture

```mermaid
flowchart TD
    A[Developer change] --> B{Trigger}
    B -->|PR or push| C[Lint and compile]
    B -->|Manual| D{Enabled?}
    D -->|No| E[Guidance only]
    D -->|Yes| F[GitHub Environment]
    F --> G[OIDC login]
    G --> H[Validate]
    H --> I[What-If]
    I --> J{Preview or deploy}
```

Validation needs no credentials. Manual deployment avoids accidental provisioning. OIDC avoids long-lived secrets. GitHub Environments can isolate variables and approvals. Existing resource groups reduce the example identity's required scope. What-If exposes intended change before deployment.

Private endpoints, DNS, diagnostics, Azure Policy, Defender, rollback, application delivery, and multi-region recovery are intentional future extensions.
