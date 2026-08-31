# Frequently asked questions

## Does cloning this repository deploy Azure resources?

No. Validation uses no Azure credentials. Deployment is manual and disabled unless an owner adds the enable variable and OIDC configuration.

## Must I have an Azure account?

Not for reading, reviewing, or observing the validation workflow. Azure access is required only for server validation, What-If, or deployment.

## Where are secrets stored?

None are required for the OIDC design. The repository uses non-secret identifiers as variables. Workload secrets would need an approved secret-management design outside this sample.

## Why is What-If not automatic on every pull request?

Azure What-If requires authenticated target access. The project keeps PR validation credential-free and makes Azure-backed preview deliberate.

## Can this deploy an Azure Function?

It can be extended. Normally Bicep provisions infrastructure, while a later job builds/tests an application artifact and deploys it after infrastructure succeeds.

## Is GRS always correct for production?

No. It is illustrative. Choose redundancy based on recovery objectives, data residency, availability, performance, and cost.

## Why do Storage keys not work?

Shared-key access is deliberately disabled. Use Entra ID and the appropriate Storage data-plane role.

## Is successful Bicep compilation proof of a successful deployment?

No. Compilation catches language/type issues. Azure validation, policy, permissions, quotas, naming availability, and runtime conditions are target-specific.

