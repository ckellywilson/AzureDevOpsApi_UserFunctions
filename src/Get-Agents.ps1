Set-StrictMode -Version 3.0

function Get-Agents {
    [CmdletBinding()]
    param (
        # PAT
        [Parameter(Mandatory = $true)]
        [string]
        $PAT,
        # ADOApiVersion
        [Parameter(Mandatory = $true)]
        [string]
        $ADOApiVersion,
        # ADOOrg
        [Parameter(Mandatory = $true)]
        [string]
        $ADOOrg,
        # PoolID
        [Parameter(Mandatory = $true)]
        [string]
        $PoolID
    )
    
    process {
        [hashtable]$ADOAuthenticationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        [string]$UriVSSPSBase = "https://dev.azure.com/"
        [string]$UriAgents = $UriVSSPSBase + "$($ADOOrg)/_apis/distributedtask/pools/$($PoolID)/agents?$($ADOAPIVersion)"
        [PSObject[]]$Agents = (Invoke-RestMethod -Uri $UriAgents -Method Get -Headers $ADOAuthenticationHeader)[0].value
        # $ADOAgents = [System.Collections.Specialized.OrderedDictionary]@{}       
        
        return $Agents
    }

}