param keyVaultName string
param location string
param adminObjectId string
param tags object
param logAnalyticsName string
param diagnosticSettingName string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: { family: 'A', name: 'standard' }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
  }
}

resource kvAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, keyVaultName, adminObjectId, 'KeyVaultAdmin')
  scope: kv
  properties: {
    principalId: adminObjectId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '00482a5a-887f-4fb3-b363-3b7fe8e74483' // Key Vault Administrator
    )
  }
}

// Reference the existing Log Analytics workspace (optional but useful for dependency)
resource existingLAW 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsName
}

 // Enable Diagnostic Settings - Key Vault

resource keyVaultDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  scope: kv
  properties: {
    workspaceId: existingLAW.id
    logs: [
      {
        categoryGroup: 'audit'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
  dependsOn: [
    existingLAW
  ]
}

output keyVaultId string = kv.id
output keyVaultUri string = kv.properties.vaultUri
