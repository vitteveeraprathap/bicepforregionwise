targetScope = 'resourceGroup'

@description('Name of the resource group (used in lock naming)')
param resourceGroupLockName string

@description('Lock level: CanNotDelete or ReadOnly')
@allowed([
  'CanNotDelete'
  'ReadOnly'
])
param lockLevel string

@description('Purpose or note for this lock')
param lockNotes string

resource rgLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: resourceGroupLockName
  properties: {
    level: lockLevel
    notes: lockNotes
  }
}
