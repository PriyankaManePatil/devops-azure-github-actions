# Production readiness

This repository teaches a secure delivery pattern; it is not a complete enterprise landing zone.

## Reference versus production

| Area | Reference choice | Production questions |
|---|---|---|
| Scope | Existing resource group | Subscription strategy and vending |
| Network | Public endpoint enabled | Private endpoints, DNS, egress |
| Identity | One OIDC pattern | Separate identities and RBAC per environment |
| Approval | Optional GitHub Environment | Segregation of duties and evidence |
| Observability | Not provisioned | Logs, metrics, alerts, retention |
| Recovery | Not implemented | Backup, restore, RTO/RPO, regional failure |
| Policy | Documented only | Azure Policy and exemption governance |
| Rollback | Manual decision | Roll-forward/rollback playbook |
| Cost | Small example | Budgets, forecasting, chargeback |

## Before adoption

Document ownership, supported regions, naming standards, tags, RBAC, data classification, network controls, monitoring, incident response, retention, cost approval, deployment evidence, and resource-deletion authority.

Infrastructure rollback is not always safe. Deleting a newly declared state may delete data. Prefer a reviewed roll-forward when possible and test recovery procedures before production.

