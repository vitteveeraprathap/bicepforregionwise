targetScope = 'resourceGroup'

@description('Azure Container Registry name (must be globally unique)')
param acrName string

@description('Deployment location')
param location string = resourceGroup().location

@description('ACR SKU (Basic, Standard, Premium)')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Basic'

@description('Enable admin user access')
param adminUserEnabled bool

@description('Custom tags for the ACR')
param tags object

param logAnalyticsName string
param diagnosticSettingName string

resource acr 'Microsoft.ContainerRegistry/registries@2025-05-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: sku
  }
  tags: tags
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: 'Enabled'
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: false
    encryption: {
      status: 'disabled'
    }
    policies: {
      retentionPolicy: {
        days: 7
        status: 'disabled'
      }
      exportPolicy: {
        status: 'enabled'
      }
      azureADAuthenticationAsArmPolicy: {
        status: 'enabled'
      }
    }
  }
}

// Reference the existing Log Analytics workspace (optional but useful for dependency)
resource existingLAW 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsName
}

// -----------------------------
// Resource: Diagnostic Settings for ACR
// -----------------------------
resource acrDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  scope: acr
  properties: {
    workspaceId: existingLAW.id
    logs: [
      {
        category: 'ContainerRegistryRepositoryEvents'
        enabled: true
      }
      {
        category: 'ContainerRegistryLoginEvents'
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
}

output acrName string = acr.name
output acrLoginServer string = acr.properties.loginServer
