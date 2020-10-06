Set-StrictMode -Version 3.0
function Get-ADOAADUsers {
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
        $ADOOrg
    )
    
    process {
        [hashtable]$ADOAuthenticationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        [string]$UriVSSPSBase = "https://vssps.dev.azure.com/"
        [string]$UriUsers = $UriVSSPSBase + "$($ADOOrg)/" + "_apis/graph/users?subjectTypes=aad&" + $ADOAPIVersion
        [PSObject[]]$Users = (Invoke-RestMethod -Uri $UriUsers -Method Get -Headers $ADOAuthenticationHeader)[0].value
        $ADOAADUsers = [System.Collections.Specialized.OrderedDictionary]@{}


        foreach ($item in $Users) {
            $ADOAADUsers[$item.displayName] = $item.descriptor
        }
        
        return $ADOAADUsers
    }
    
}