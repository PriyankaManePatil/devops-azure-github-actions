// Deploy into an existing resource group so the GitHub identity needs less scope.
targetScope = 'resourceGroup'

// Restrict values so spelling mistakes fail during validation.
@allowed(['dev', 'test', 'prod'])
@description('Logical environment used for configuration, naming, and tags.')
param environment string

// Storage names are globally unique, lowercase, and at most 24 characters.
@minLength(3)
@maxLength(12)
@description('Short project identifier used in names and tags.')
param projectName string = 'devopsref'

@description('Azure region; defaults to the resource group location.')
param location string = resourceGroup().location

// Never put secrets in tags or committed parameter files.
@description('Optional non-secret tags merged with required tags.')
param additionalTags object = {}

// Storage names permit only lowercase letters and numbers.
var normalizedProject = toLower(replace(projectName, '-', ''))

// uniqueString is deterministic for this subscription/resource-group pair.
// take(..., 24) enforces the Storage Account name-length limit.
var storageName = take('${normalizedProject}${environment}${uniqueString(subscription().id, resourceGroup().id)}', 24)

// One resource keeps this example focused on CI/CD and Bicep fundamentals.
resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageName
  location: location
  tags: union({
    environment: environment
    project: projectName
    managedBy: 'Bicep'
    purpose: 'education-reference'
  }, additionalTags)
  sku: {
    // Demonstrate geo-redundancy in prod and lower-cost LRS elsewhere.
    name: environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    // Prefer Entra ID and modern transport security over anonymous/key access.
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    // Kept enabled for learning simplicity; production should assess private endpoints.
    publicNetworkAccess: 'Enabled'
    // Infrastructure encryption adds a second Microsoft-managed encryption layer.
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: true
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
  }
}

// Outputs expose useful identifiers without exposing secrets.
output storageAccountName string = storage.name
output storageAccountId string = storage.id
output primaryBlobEndpoint string = storage.properties.primaryEndpoints.blob
