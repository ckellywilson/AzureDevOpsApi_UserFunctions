Set-StrictMode -Version 3.0
function Get-ADOCheckGroups {
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
        # ADOGroupList
        [Parameter(Mandatory = $true)]
        [string[]]
        $ADOGroupList
    )
    
    process {
        [hashtable]$ADOAuthenticationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        [string]$UriVSSPSBase = "https://vssps.dev.azure.com/"
        [string]$UriGroups = $UriVSSPSBase + "$($ADOOrg)/" + "_apis/graph/groups?" + $ADOAPIVersion
        [PSObject[]]$ADOGroups = (Invoke-RestMethod -Uri $UriGroups -Method Get -Headers $ADOAuthenticationHeader)[0].value
        $ADOCheckGroups = [System.Collections.Specialized.OrderedDictionary]@{}

        foreach ($ADOGroup in $ADOGroups) {
            if ($ADOGroupList.Contains($ADOGroup.displayName)) {

                $ADOCheckGroups[$ADOGroup.displayName] = $ADOGroup.descriptor
            }        
        }

        return $ADOCheckGroups
    }
    
}