<#
.NOTES
    Script Name: 04-Get-Apps-Winget.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 4/26/2023
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.

.SYNOPSIS
    This script will use PSSession to connect to a list of hostnames.
    Next, it will try to copy an exported Winget package file in JSON format.
    Finally, it will try to install the packages in the JSON file using Winget.
    
.DESCRIPTION
    This script uses Winget to import a list of packages and installs them.

.EXAMPLE
    .\04-Get-Apps-Winget.ps1 <arguments>    
#>

$HostNames = Get-Content ".\hostnames.txt"
$localFilePath = ".\winget-packages.json"

try {
    ForEach ($HostName in $HostNames) {     
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)         
        $localFilePath = ".\winget-packages.json" 
        $remoteFilePath = "\\$HostName\$env:TEMP"
        Write-Host "Trying to copy winget-packages.json..."
        Copy-Item -Path $localFilePath -Destination $remoteFilePath        
        Invoke-Command -Session $PSSession -ScriptBlock {
            Write-Host `r
            Write-Host "hostname:" (hostname)
            Write-Host "whoami:" (whoami)                                   
            # Install more apps using winget and a import file
            Write-Host "Check if winget-packages.json exists (should return true)"
            Test-Path -Path "$env:TEMP\winget-packages.json"
            Set-Location -Path "$env:TEMP\" | winget import --import-file .\winget-packages.json --accept-package-agreements    # Install one or more apps using winget and an import file
            Remove-Item -Path "$env:TEMP\winget-packages.json" # clean up by removing the winget import file
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