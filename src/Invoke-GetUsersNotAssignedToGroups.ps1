Set-StrictMode -Version 3.0
[string]$PAT = "bwlr5xtrvdousysrr4dpyijphn22vgex7746jcldmlnst3y5keuq"
[string]$ADOOrg = "ckwilson4gmail"
[string]$ADOAPIVersion = "api-version=6.0-preview.1"
[string[]]$ADOGroupList = @("ckwilson4gmail Group")
[System.Collections.Specialized.OrderedDictionary]$ADOGroups = $null
[System.Collections.Specialized.OrderedDictionary]$ADOAADUsers = $null
[System.Collections.ArrayList]$ADOUsersNotInGroups = @()

. .\src\Get-ADOGroups.ps1
. .\src\Get-ADOAADUsers.ps1
. .\src\Find-UserInGroup.ps1

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