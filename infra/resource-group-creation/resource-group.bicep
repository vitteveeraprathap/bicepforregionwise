targetScope = 'subscription'

@allowed([
  'dev'
  'sbx'
  'uat'
  'prd'
])
param environment string

@allowed([
  'wus2'
  'cnd'
  'eus'
  'ind'
])
param regionCode string

param location string   // westus2, eastus, canadacentral, centralindia
param projectCode string   // btt, iit, bot, ntt...

param tags object

// Auto-generate resource group name
var rgName = 'rg-${projectCode}-${environment}-${regionCode}-001'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location

  // 🔥 Override tags dynamically so application tag = projectCode
  tags: union(tags, {
    name: rgName
    environment: environment
    project: projectCode
    application: projectCode     // <---- super important override
  })
}

output resourceGroupName string = rgName
