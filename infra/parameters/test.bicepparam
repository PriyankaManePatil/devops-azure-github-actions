using '../main.bicep'
param environment = 'test'
param additionalTags = {
  costCenter: 'learning'
  owner: 'platform-engineering'
}
