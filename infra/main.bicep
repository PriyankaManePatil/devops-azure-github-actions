targetScope = 'resourceGroup'

@allowed(['dev', 'test', 'prod'])
param environment string

@minLength(3)
@maxLength(12)
param projectName string = 'devopsref'

param location string = resourceGroup().location
param additionalTags object = {}

var normalizedProject = toLower(replace(projectName, '-', ''))
var storageName = take('${normalizedProject}${environment}${uniqueString(subscription().id, resourceGroup().id)}', 24)

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
    name: environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Enabled'
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

output storageAccountName string = storage.name
output storageAccountId string = storage.id
output primaryBlobEndpoint string = storage.properties.primaryEndpoints.blob
