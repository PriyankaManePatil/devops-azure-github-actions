// Development values for inexpensive experimentation.
// This committed file must never contain secrets.
using '../main.bicep'
param environment = 'dev'
param additionalTags = {
  costCenter: 'learning'
  owner: 'platform-engineering'
}
