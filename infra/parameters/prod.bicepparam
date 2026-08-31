using '../main.bicep'
param environment = 'prod'
param additionalTags = {
  costCenter: 'learning'
  owner: 'platform-engineering'
  criticality: 'reference-only'
}
