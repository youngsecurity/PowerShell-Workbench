# Copyright (c) Young Security Inc.
# Licensed under the MIT License.
<#
.Synopsis
    Get PowerShell Latest and Pre-release Version from GitHub for Windows, Linux or macOS.
.DESCRIPTION
    By default, the latest available PowerShell release and pre-release package will be checked.    
.EXAMPLE
    Check the latest release and pre-release build
    .\get-psversion.ps1
.EXAMPLE
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

$currentVersion = $PSVersionTable.PSVersion.ToString()

if ($currentVersion -like "*preview*") {    
    Write-Host "You are running a preview version of PowerShell."
    $latestPrereleaseUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases"
    $checklatestPrerelease = Invoke-RestMethod -Uri $latestPreReleaseUrl
    $latestPrerelease = ($checklatestPrerelease | Where-Object { $_.prerelease -eq $true } | Select-Object -First 1).tag_name
    
    if ($latestPrerelease -gt $currentVersion) {
        Write-Host "A new pre-release version of PowerShell is available!"
        Write-Host "Latest GitHub pre-release version: $latestPrerelease"
        Write-Host "Your Current version: $currentVersion"
    } else {
        Write-Host "You have the latest pre-release version of PowerShell."
        Write-Host "Your Current version: $currentVersion"
    }
} else {
    Write-Host "You are running a stable version of PowerShell."
    $latestReleaseUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
    $latestRelease = Invoke-RestMethod -Uri $latestReleaseUrl
    $latestVersion = $latestRelease.tag_name

    if ($latestVersion -gt $currentVersion) {
        Write-Host "A new version of PowerShell is available!"
        Write-Host "Latest GitHub version: $latestVersion"
        Write-Host "Your Current version: $currentVersion"
    } else {
        Write-Host "You have the latest version of PowerShell."
        Write-Host "Your Current version: $currentVersion"
    }
}