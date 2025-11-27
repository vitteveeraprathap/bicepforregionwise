@description('Name of the Log Analytics Workspace')
param logAnalyticsName string

@description('Location for the Log Analytics Workspace')
param location string

@description('Retention period in days for logs')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

param tags object

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsName
  location: location
  tags: tags
  properties: {
    retentionInDays: retentionInDays
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
  sku: {
    name: 'PerGB2018' // Recommended for pay-as-you-go workloads
  }
}
