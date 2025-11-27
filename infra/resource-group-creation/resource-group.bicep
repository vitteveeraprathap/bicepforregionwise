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

// Full Azure physical location: westus2, eastus, canadacentral, centralindia, etc.
param location string

// Dynamic project code: btt, iit, bot, ntt, etc
param projectCode string

param tags object

// Generate RG name automatically
var rgName = 'rg-${projectCode}-${environment}-${regionCode}-001'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: union(tags, {
    name: rgName
    environment: environment
    project: projectCode
  })
}

output resourceGroupName string = rgName
