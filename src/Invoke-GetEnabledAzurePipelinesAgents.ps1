Set-StrictMode -Version 3.0

############################# PARAMETERS ###############################
# Personal Access Token https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page
[string]$PAT = "bwlr5xtrvdousysrr4dpyijphn22vgex7746jcldmlnst3y5keuq"

# Name of the ADO Org targeted
[string]$ADOOrg = "ckwilson4gmail"

# Version https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
[string]$ADOAPIVersion = "api-version=6.0-preview.1"

# Variables used in execution
[System.Collections.Specialized.OrderedDictionary]$ADOPools = $null
[pscustomobject]$ADOAgents = $null
[string]$PoolName = 'Azure Pipelines'

# Reference Scripts
. .\src\Get-AgentPools.ps1
. .\src\Get-Agents.ps1

$ADOPools = Get-AgentPools $PAT $ADOAPIVersion $ADOOrg $PoolName
$ADOAgents = Get-Agents $PAT $ADOAPIVersion $ADOOrg $ADOPools.Keys[0]

foreach ($item in $ADOAgents) {
    if ($item.enabled -eq $true) {
        Write-Host -ForegroundColor Red "Pool $($ADOPools.Values[0]), has the agent $($item.Name) enabled"
    }
}

