targetScope = 'subscription'

@allowed([
  'dev'
  'sbx'
  'uat'
  'prd'
])
param environment string

@allowed([
  'scus'
  'wcus'
  'wus3'
  'cus'
])
param regionCode string

param location string   // southcentralus, westcentralus, westus3, centralus
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
