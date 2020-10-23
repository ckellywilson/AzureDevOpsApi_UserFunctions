Set-StrictMode -Version 3.0

function Get-AgentPools {
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
        # Pool Name
        [Parameter(Mandatory = $true)]
        [string]
        $PoolName
    )
    
    process {
        [hashtable]$ADOAuthenticationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        [string]$UriVSSPSBase = "https://dev.azure.com/"
        [string]$UriPools = $UriVSSPSBase + "$($ADOOrg)/_apis/distributedtask/pools?poolName=$($PoolName)&$($ADOAPIVersion)"
        [PSObject[]]$Pools = (Invoke-RestMethod -Uri $UriPools -Method Get -Headers $ADOAuthenticationHeader)[0].value
        $ADOPools = [System.Collections.Specialized.OrderedDictionary]@{}


        foreach ($item in $Pools) {
            $ADOPools[$item.id] = $item.name
        }
        
        return $ADOPools
    }
    
}