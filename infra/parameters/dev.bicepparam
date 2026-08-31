using '../main.bicep'
param environment = 'dev'
param additionalTags = {
  costCenter: 'learning'
  owner: 'platform-engineering'
}
