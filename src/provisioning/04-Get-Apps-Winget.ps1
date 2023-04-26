<#
.NOTES
    Script Name: 02-Get-PSRemoting.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 4/26/2023
    Copyright: (c) Young Security Inc.
    Licensed: under the MIT License.

.SYNOPSIS
    Get PowerShell Latest and Pre-release Version from GitHub for Windows, Linux or macOS.
    
.DESCRIPTION
    This is script checks for WinRM remoting on a single host or a list of hosts

.EXAMPLE
    .02-Get-PSRemoting.ps1 <arguments>    
#>
$HostNames = Get-Content ".\hostnames.txt"
$localFilePath = ".\winget-packages.json"

try {
    ForEach ($HostName in $HostNames) {     
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)         
        $localFilePath = ".\winget-packages.json" 
        $remoteFilePath = "\\$HostName\C$\Users\Public\Downloads\"
        Write-Host "Trying to copy winget-packages.json..."
        Copy-Item -Path $localFilePath -Destination $remoteFilePath        
        Invoke-Command -Session $PSSession -ScriptBlock {
            Write-Host `r
            Write-Host "hostname:" (hostname)
            Write-Host "whoami:" (whoami)                                   
            # Install more apps using winget and a import file
            Write-Host "Check if winget-packages.json exists (should return true)"
            Test-Path -Path "C:\Users\Public\Downloads\winget-packages.json"
            Set-Location -Path "C:\Users\Public\Downloads\" | winget import --import-file .\winget-packages.json --accept-package-agreements    # Install one or more apps using winget and an import file
            Remove-Item -Path "C:\Users\Public\Downloads\winget-packages.json" # clean up by removing the winget import file
            # Install Chocolatey package manager
            # Step 1: Copy 04-Get-Choco.ps1, and run it locally, or run it remotely
            # Step 2: After Choco is installed, 

        } -ErrorAction Continue        
    }    
}
catch {    
    Write-Host "An Error Occured" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    Write-Host `r`n
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}

# Check for Hyper-V
#Get-WindowsOptionalFeature -Online -FeatureName *Hyper-v* | Where-Object { $_.State -eq "Enabled" }