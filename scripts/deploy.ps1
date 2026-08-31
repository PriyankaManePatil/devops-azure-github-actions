[CmdletBinding()]
param(
    [ValidateSet('dev', 'test', 'prod')] [string]$Environment = 'dev',
    [ValidateSet('Validate', 'WhatIf', 'Deploy')] [string]$Mode = 'Validate',
    [string]$ResourceGroupName,
    [string]$DeploymentName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$template = Join-Path $root 'infra/main.bicep'
$parameters = Join-Path $root "infra/parameters/$Environment.bicepparam"

if (-not (Get-Command az -ErrorAction SilentlyContinue)) { throw 'Azure CLI is required.' }
az bicep lint --file $template
if ($LASTEXITCODE -ne 0) { throw 'Bicep lint failed.' }
az bicep build --file $template --stdout | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Bicep compilation failed.' }
az bicep build-params --file $parameters --stdout | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Parameter compilation failed.' }

if ($Mode -eq 'Validate') {
    Write-Host 'Validation completed. No Azure operation was performed.'
    return
}
if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) { throw 'ResourceGroupName is required.' }
if ([string]::IsNullOrWhiteSpace($DeploymentName)) { $DeploymentName = "local-$Environment-$(Get-Date -Format 'yyyyMMdd-HHmmss')" }
az account show --output none
if ($LASTEXITCODE -ne 0) { throw 'Run az login and select the intended subscription.' }
az group show --name $ResourceGroupName --output none
if ($LASTEXITCODE -ne 0) { throw "Resource group is inaccessible: $ResourceGroupName" }
az deployment group what-if `
  --name $DeploymentName `
  --resource-group $ResourceGroupName `
  --parameters $parameters `
  --result-format FullResourcePayloads
if ($LASTEXITCODE -ne 0) { throw 'What-If failed.' }
if ($Mode -eq 'WhatIf') { return }
$confirmation = Read-Host "Type DEPLOY to apply changes to '$ResourceGroupName'"
if ($confirmation -cne 'DEPLOY') { throw 'Deployment cancelled.' }
az deployment group create `
  --name $DeploymentName `
  --resource-group $ResourceGroupName `
  --parameters $parameters `
  --output table
if ($LASTEXITCODE -ne 0) { throw 'Deployment failed.' }
