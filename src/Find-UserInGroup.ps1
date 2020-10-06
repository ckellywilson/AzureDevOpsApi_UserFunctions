Set-StrictMode -Version 3.0
function Find-UserInGroup {
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
        # UserDescriptor
        [Parameter(Mandatory = $true)]
        [string]
        $UserDescriptor,
        # GroupDictionary
        [Parameter(Mandatory = $true)]
        [System.Collections.Specialized.OrderedDictionary]
        $GroupDictionary
    )
    
    process {
        [hashtable]$ADOAuthenticationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        [string]$UriVSSPSBase = "https://vssps.dev.azure.com/"
        $MembershipsUri = $UriVSSPSBase + "$($ADOOrg)/" + "_apis/graph/memberships/$($UserDescriptor)?" + $ADOAPIVersion
        $Memberships = (Invoke-RestMethod -Uri $MembershipsUri -Method Get -Headers $ADOAuthenticationHeader)[0].value
        [bool]$InGroup = $false

        foreach ($item in $Memberships) {
            foreach ($entry in $GroupDictionary.Keys) {
                if ($item.containerDescriptor -eq $GroupDictionary[$entry]) {
                    $InGroup = $true;
                    break;
                }
            }
        }

        return $InGroup
    }
}