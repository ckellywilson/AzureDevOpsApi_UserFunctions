# AzureDevOpsApi_UserFunctions
_NOTE: This code sample is as-is and not intended for production use_

This code example shows how to use the [Azure DevOps Services API](https://docs.microsoft.com/en-us/rest/api/azure/devops/?view=azure-devops-rest-6.1)

Perform the following:
1. Open the file, _Invoke-GetUsersNotAssignedToGroups.ps1_ in PowerShell ISE, Visual Studio or Visual Studio Code
2. Set the parameters at the top of the file

`############################# PARAMETERS ###############################`

`# Personal Access Token` [Azure DevOps Personal Access Token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page)

`[string]$PAT = "<your token>"`

`# Name of the ADO Org targeted`

`[string]$ADOOrg = "<your org>"`

`# Version of Azure DevOps to call`

`[string]$ADOAPIVersion = "api-version=6.0-preview.1"` [Azure DevOps Api REST Versioning](https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops)

`# Array of ADOGroups to search for membership`

`[string[]]$ADOGroupList = @("Test Group 1", "Test Group 2")`

3. Execute script to show users not assigned to groups