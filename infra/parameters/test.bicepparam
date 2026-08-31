// Test values for stable pre-production validation.
// This committed file must never contain secrets.
using '../main.bicep'
param environment = 'test'
param additionalTags = {
  costCenter: 'learning'
  owner: 'platform-engineering'
}
