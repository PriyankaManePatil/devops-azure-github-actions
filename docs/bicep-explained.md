# Bicep explained

## Template anatomy

`targetScope = 'resourceGroup'` states where the deployment runs. Parameters are caller-supplied inputs; variables are derived internal values; resources describe desired Azure state; outputs return useful non-secret results.

## Parameters and decorators

| Element | Reason |
|---|---|
| `environment` | Drives tags, naming, and redundancy |
| `@allowed` | Rejects unsupported environment values |
| `projectName` | Reusable naming input |
| `@minLength/@maxLength` | Protects the Storage naming calculation |
| `location` | Defaults consistently to resource-group location |
| `additionalTags` | Lets environments add non-secret metadata |
| `@description` | Provides help to tooling and readers |

## Unique name calculation

Storage Account names are global, lowercase, 3–24 characters, and alphanumeric. The template:

1. removes hyphens and lowercases the project name;
2. adds the environment;
3. adds a deterministic `uniqueString` suffix;
4. truncates the result to 24 characters.

`uniqueString` is deterministic, not secret and not random. The same seed produces the same result.

## Security decisions

| Setting | Rationale |
|---|---|
| `supportsHttpsTrafficOnly` | Reject HTTP |
| `minimumTlsVersion` | Require TLS 1.2 or later |
| `allowBlobPublicAccess: false` | Prevent anonymous Blob containers |
| `allowSharedKeyAccess: false` | Prefer identity-based authorization |
| `defaultToOAuthAuthentication` | Prefer Entra authentication in tools |
| Infrastructure encryption | Additional encryption layer |

Public networking remains enabled to avoid adding private DNS/network prerequisites to a beginner project. This is an explicit teaching tradeoff, not a universal production recommendation.

## Environment difference

Dev/test use LRS for lower cost. Prod demonstrates GRS. This is illustrative; actual redundancy must follow workload recovery, residency, availability, and cost requirements.

## Parameter files

The `using '../main.bicep'` statement connects each `.bicepparam` file to the template and enables type checking. Parameter files are source-controlled configuration and must not contain credentials.

## Outputs

Outputs provide the deployed name, resource ID, and Blob endpoint. They can feed later application-deployment jobs, documentation, or tests. Outputs must never disclose secrets.

