<#
.NOTES
    Script Name: PSNotes-InvokeFromGitHub.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 5/8/2023
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.
.SYNOPSIS
    Invoke a script from a private GitHub Repo
.DESCRIPTION
    Describe how the script is invoked from a private GitHub Repo
.EXAMPLE
    .\PSNotes-InvokeFromGitHub.ps1
    Invoke this script directly from a Private GitHub Repo
    Invoke-Expression "& { $(Invoke-RestMethod 'https://raw.githubusercontent.com/$username/$repoName/master/$scriptPath') }"
    $token = "YOUR_GITHUB_PERSONAL_ACCESS_TOKEN"
    $username = "YOUR_GITHUB_USERNAME"
    $repoName = "YOUR_PRIVATE_REPO_NAME"
    $scriptPath = "PATH_TO_YOUR_SCRIPT_ON_GITHUB"

    $headers = @{
        "Authorization" = "token $token"
    }

    $rawUrl = "https://raw.githubusercontent.com/$username/$repoName/master/$scriptPath"

    $scriptContent = Invoke-RestMethod -Uri $rawUrl -Headers $headers

    Invoke-Expression -Command $scriptContent
#>