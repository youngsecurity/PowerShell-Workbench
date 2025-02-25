# Copyright (c) Young Security Inc.
# Licensed under the MIT License.
<#
.SYNOPSIS
    Get PowerShell Latest and Pre-release Version from GitHub for Windows, Linux or macOS.
.DESCRIPTION
    By default, the latest available PowerShell release and pre-release package will be checked.    
.EXAMPLE
    Check the latest release and pre-release build
    .\Get-PSversion.ps1
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

Write-Host "Please choose one of the following options:"
Write-Host "1. Enter a single hostname"
Write-Host "2. Enter a file containing hostnames"
Write-Host "3. Quit"

$selection = Read-Host "Enter your selection (1, 2, or 3)"

switch ($selection) {
    1 {
        Write-Host "You selected Option One."
        $HostName = Read-Host "Enter a hostname"
        Write-Host "You entered the hostname: $HostName"
        try {
            $currentVersion = $PSVersionTable.PSVersion.ToString()
            if ($currentVersion -like "*preview*") {    
                Write-Host "You are running a preview version of PowerShell."
                $latestPrereleaseUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases"
                $checklatestPrerelease = Invoke-RestMethod -Uri $latestPreReleaseUrl
                $latestPrerelease = ($checklatestPrerelease | Where-Object { $_.prerelease -eq $true } | Select-Object -First 1).tag_name
                Write-Host $latestPrerelease                
                if ($latestPrerelease -gt "v$currentVersion") {
                    Write-Host "A new pre-release version of PowerShell is available!"
                    Write-Host "Latest GitHub pre-release version: $latestPrerelease"
                    Write-Host "Your Current version: v$currentVersion"
                } else {
                    Write-Host "You have the latest pre-release version of PowerShell."
                    Write-Host "Your Current version: v$currentVersion"
                }
            } else {
                Write-Host "You are running a stable version of PowerShell."
                $latestReleaseUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
                $latestRelease = Invoke-RestMethod -Uri $latestReleaseUrl
                $latestVersion = $latestRelease.tag_name
                if ($latestVersion -gt "v$currentVersion") {
                    Write-Host "A new version of PowerShell is available!"
                    Write-Host "Latest GitHub version: $latestVersion"
                    Write-Host "Your Current version: v$currentVersion"
                } else {
                    Write-Host "You have the latest version of PowerShell."
                    Write-Host "Your Current version: v$currentVersion"
                }
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            # Do this if a terminating exception happens
            Write-Host "The $HostName was not found." -ForegroundColor Red    
        }
        catch {
            # Write out the exception message to the host
            Write-Host $PSItem.Exception.Message -ForegroundColor Red
        }
        finally {
            # Do this after the try block regardless of whether an exception occurred or not
            # Clears the error
            $Error.Clear()
        }
    }
    2 {
        Write-Host "You selected Option Two."
        $filePath = Read-Host "Enter the file path containing hostnames"
        Write-Host "You entered the file path: $filePath"
        # Declare the variable and content to import the list of hostanmes or IP addresses
        $Hosts = Get-Content $filePath
        try {
            ForEach ($HostName in $Hosts) {
                # Try something
                $currentVersion = $PSVersionTable.PSVersion.ToString()
                if ($currentVersion -like "*preview*") {    
                    Write-Host "You are running a preview version of PowerShell."
                    $latestPrereleaseUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases"
                    $checklatestPrerelease = Invoke-RestMethod -Uri $latestPreReleaseUrl
                    $latestPrerelease = ($checklatestPrerelease | Where-Object { $_.prerelease -eq $true } | Select-Object -First 1).tag_name
                    Write-Host $latestPrerelease                    
                    if ($latestPrerelease -gt "v$currentVersion") {
                        Write-Host "A new pre-release version of PowerShell is available!"
                        Write-Host "Latest GitHub pre-release version: $latestPrerelease"
                        Write-Host "Your Current version: v$currentVersion"
                    } else {
                        Write-Host "You have the latest pre-release version of PowerShell."
                        Write-Host "Your Current version: v$currentVersion"
                    }
                } else {
                    Write-Host "You are running a stable version of PowerShell."
                    $latestReleaseUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
                    $latestRelease = Invoke-RestMethod -Uri $latestReleaseUrl
                    $latestVersion = $latestRelease.tag_name    
                    if ($latestVersion -gt "v$currentVersion") {
                        Write-Host "A new version of PowerShell is available!"
                        Write-Host "Latest GitHub version: $latestVersion"
                        Write-Host "Your Current version: v$currentVersion"
                    } else {
                        Write-Host "You have the latest version of PowerShell."
                        Write-Host "Your Current version: v$currentVersion"
                    }
                }
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            # Do this if a terminating exception happens
            Write-Host "An Error Occured" -ForegroundColor Red
            Write-Host "The $HostName was not found." -ForegroundColor Red    
        }
        catch {
            # Write out the exception message to the host
            Write-Host $PSItem.Exception.Message -ForegroundColor Red
        }
        finally {
            # Do this after the try block regardless of whether an exception occurred or not
            # Clears the error
            $Error.Clear()
        }
    }
    3 {
        Write-Host "Quitting script..."
        return
    }
    default {
        Write-Host "Invalid selection. Please enter 1, 2, or 3."
    }
}