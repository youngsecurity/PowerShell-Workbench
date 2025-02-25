<#
.NOTES
    Script Name: 06-GetApps-Python.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 4/29/2023
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.

.SYNOPSIS
    This script will check for the latest version of Python on the localhost or a list of hosts.
    Next, it will compare that version with what is installed.
    Finally, if the local version is outdated, the latest version of Python will be installed.
    
.DESCRIPTION
    This script checks for the latest version of Python and installs it if the version is outdated.

.EXAMPLE
    .\06-GetApps-Python.ps1 <arguments>    
#>
try {
    # Get the local version of Python
    $localVersion = python --version 2>&1 | Out-String
    # Extract the version number from the localversion string
    $localVersionNumber = $localVersion -replace 'Python ([0-9]+\.[0-9]+\.[0-9]+).*', '$1'
    Write-Host "The local version of Python for Windows is $localVersionNumber"
    # Get the latest version of Python from the web
    $webResponse = Invoke-WebRequest -Uri "https://www.python.org/downloads/"
    $webPage = $webResponse.Content
    $pattern = "Download Python (\d+\.\d+\.\d+)"
    if ($webPage -match $pattern) {
        $latestVersionNumber = $matches[1]
        Write-Host "The latest online version of Python for Windows is $latestVersionNumber"
    }
    else {
        Write-Host "Error: Unable to determine latest version of Python for Windows"
    }    
    # Compare the local and latest web versions
    $webVersionNumber = $latestVersionNumber
    if ($localVersionNumber -lt $webVersionNumber) {
        # Download and install the latest version of Python
        Write-Host "Local version of Python is outdated. Downloading and installing the latest version..."
        $pythonDownloadUrl = "https://www.python.org/ftp/python/$webVersionNumber/python-$webVersionNumber-amd64.exe"
        $pythonInstallerPath = "$env:TEMP\python-$webVersionNumber-amd64.exe"
        Invoke-WebRequest -Uri $pythonDownloadUrl -OutFile $pythonInstallerPath
        $installFilePath = Read-Host "Enter the path to install Python"
        Start-Process $pythonInstallerPath -ArgumentList "/passive", "TargetDir=""$installFilePath""", "PrependPath=1" -Wait
        # If the installation path is known ahead of time, you can use the following line instead:
        #Start-Process $pythonInstallerPath -ArgumentList "/passive", "TargetDir=""F:\Program Files\Python\Python$webVersionNumber""", "PrependPath=1" -Wait        
        Write-Host "Latest version of Python has been installed."
        Write-Host "Cleaning up..."
        Remove-Item $pythonInstallerPath
    }
    else {
        # The local version of Python is up-to-date
        Write-Host "Local version of Python is up-to-date."
    }
}
catch {
    <#Do this if a Python is not found or an exception happens#>
    Write-Host "Python is not installed."
    Write-Host "Proceeding to download and install Python."
    # Get the latest version of Python from the web
    $webResponse = Invoke-WebRequest -Uri "https://www.python.org/downloads/"
    $webPage = $webResponse.Content
    $pattern = "Download Python (\d+\.\d+\.\d+)"
    if ($webPage -match $pattern) {
        $latestVersion = $matches[1]        
        Write-Host "Latest version of Python for Windows is $latestVersion"
        #Write-Host $latestVersion        
        Write-Host "Downloading latest version of Python for Windows."        
        $pythonDownloadUrl = "https://www.python.org/ftp/python/$latestVersion/python-$latestVersion-amd64.exe"        
        $pythonInstallerPath = "$env:TEMP\python-$latestVersion-amd64.exe"        
        Invoke-WebRequest -Uri $pythonDownloadUrl -OutFile $pythonInstallerPath        
        $installFilePath = Read-Host "Enter the path to install Python"
        Start-Process $pythonInstallerPath -ArgumentList "/passive", "TargetDir=""$installFilePath""", "PrependPath=1" -Wait
        # If the installation path is known ahead of time, you can use the following line instead:
        #Start-Process $pythonInstallerPath -ArgumentList "/passive", "TargetDir=""F:\Program Files\Python\Python$latestVersion""", "PrependPath=1" -Wait        
        Write-Host "Latest version of Python has been installed."        
        Write-Host "Cleaning up..."        
        Remove-Item $pythonInstallerPath
    }
    else {
        Write-Host "Error: Unable to determine latest version of Python for Windows"
    }
}