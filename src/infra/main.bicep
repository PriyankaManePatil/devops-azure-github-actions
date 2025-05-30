// Sample Bicep template (reference only)

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'demostorageaccount'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
