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

// RG physical location (southcentralus, centralus, etc.)
param location string

// Project code: btt, iit, bot, ntt...
param projectCode string

// Base tags from parameter file
param tags object

// RG name
var rgName = 'rg-${projectCode}-${environment}-${regionCode}-001'

// Resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location

  // Override / add dynamic tags here
  tags: union(tags, {
    name: rgName
    environment: environment
    project: projectCode
    application: projectCode
    department: '${projectCode} gdc architecture' // 🔥 dynamic department
  })
}

output resourceGroupName string = rgName
