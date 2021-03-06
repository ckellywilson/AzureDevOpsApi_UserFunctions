Set-StrictMode -Version 3.0

############################# PARAMETERS ###############################
# Personal Access Token https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page
[string]$PAT = "<your_token>"

# Name of the ADO Org targeted
[string]$ADOOrg = "<your_org>"

# Version https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
[string]$ADOAPIVersion = "api-version=6.0-preview.1"

# Array of ADOGroups to search for membership. Add these groups below ("Test Group 1", "Test Group 2") in <your_org> --> Settings --> Permissions
[string[]]$ADOGroupList = @("Test Group 1", "Test Group 2")

# Variables used in execution
[System.Collections.Specialized.OrderedDictionary]$ADOGroups = $null
[System.Collections.Specialized.OrderedDictionary]$ADOAADUsers = $null
[System.Collections.ArrayList]$ADOUsersNotInGroups = @()

. .\src\Get-ADOGroups.ps1
. .\src\Get-ADOAADUsers.ps1
. .\src\Find-UserInGroup.ps1

# Retrieve Users and Groups
$ADOAADUsers = Get-ADOAADUsers $PAT $ADOAPIVersion $ADOOrg
$ADOGroups = Get-ADOCheckGroups $PAT $ADOAPIVersion $ADOOrg $ADOGroupList

foreach ($ikey in $ADOAADUsers.Keys) {
    if ((Find-UserInGroup -PAT $PAT -ADOApiVersion $ADOAPIVersion -ADOOrg $ADOOrg -UserDescriptor $ADOAADUsers[$ikey] -GroupDictionary $ADOGroups) -ne $true) {
        $ADOUsersNotInGroups.Add($ikey)
    }
}

Write-Host "The following AAD users are not in any assigned groups"
foreach ($user in $ADOUsersNotInGroups) {
    Write-Host "$($user) has no ADO group assignments"
}