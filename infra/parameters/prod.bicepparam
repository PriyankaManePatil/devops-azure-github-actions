// Production-shaped reference values; deployment is still manual and guarded.
// This committed file must never contain secrets.
using '../main.bicep'
param environment = 'prod'
param additionalTags = {
  costCenter: 'learning'
  owner: 'platform-engineering'
  criticality: 'reference-only'
}
