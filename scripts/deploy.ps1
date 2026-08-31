<#
.SYNOPSIS
Validates or demonstrates deployment of this repository's Bicep template.

.DESCRIPTION
Every mode first runs local Bicep lint/build checks. Validate never requires
Azure access. WhatIf and Deploy require Azure CLI authentication and an existing
resource group. Deploy additionally requires the exact confirmation DEPLOY.

.PARAMETER Environment
Selects dev, test, or prod and its matching .bicepparam file.

.PARAMETER Mode
Validate checks locally; WhatIf previews Azure changes; Deploy previews then applies.

.PARAMETER ResourceGroupName
Existing Azure resource group required by WhatIf and Deploy.

.PARAMETER DeploymentName
Optional ARM deployment name; a timestamped name is generated when omitted.

.EXAMPLE
./scripts/deploy.ps1 -Environment dev -Mode Validate

.EXAMPLE
./scripts/deploy.ps1 -Environment dev -Mode WhatIf -ResourceGroupName rg-reference-dev

.NOTES
Educational reference. Confirm the active Azure subscription before Azure-backed modes.
#>
[CmdletBinding()]
param(
    [ValidateSet('dev', 'test', 'prod')] [string]$Environment = 'dev',
    [ValidateSet('Validate', 'WhatIf', 'Deploy')] [string]$Mode = 'Validate',
    [string]$ResourceGroupName,
    [string]$DeploymentName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Resolve paths from the script location so it works from any current directory.
$root = Split-Path -Parent $PSScriptRoot
$template = Join-Path $root 'infra/main.bicep'
$parameters = Join-Path $root "infra/parameters/$Environment.bicepparam"

# Fail early rather than allowing every subsequent az command to fail.
if (-not (Get-Command az -ErrorAction SilentlyContinue)) { throw 'Azure CLI is required.' }

# Local validation is intentionally mandatory for all three modes.
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
# Azure-backed modes require an explicit target and authenticated CLI session.
if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) { throw 'ResourceGroupName is required.' }
if ([string]::IsNullOrWhiteSpace($DeploymentName)) { $DeploymentName = "local-$Environment-$(Get-Date -Format 'yyyyMMdd-HHmmss')" }
az account show --output none
if ($LASTEXITCODE -ne 0) { throw 'Run az login and select the intended subscription.' }
az group show --name $ResourceGroupName --output none
if ($LASTEXITCODE -ne 0) { throw "Resource group is inaccessible: $ResourceGroupName" }
# What-If is mandatory even in Deploy mode so changes are visible first.
az deployment group what-if `
  --name $DeploymentName `
  --resource-group $ResourceGroupName `
  --parameters $parameters `
  --result-format FullResourcePayloads
if ($LASTEXITCODE -ne 0) { throw 'What-If failed.' }
if ($Mode -eq 'WhatIf') { return }
# Human confirmation protects a learner from applying changes accidentally.
$confirmation = Read-Host "Type DEPLOY to apply changes to '$ResourceGroupName'"
if ($confirmation -cne 'DEPLOY') { throw 'Deployment cancelled.' }
az deployment group create `
  --name $DeploymentName `
  --resource-group $ResourceGroupName `
  --parameters $parameters `
  --output table
if ($LASTEXITCODE -ne 0) { throw 'Deployment failed.' }
