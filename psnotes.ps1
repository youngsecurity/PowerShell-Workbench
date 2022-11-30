#
# PsExec Pre-Install Configuration
#
# Run a remote PowerShell script on a remote system using PsExec
psexec -s \\webserver Powershell -ExecutionPolicy Bypass -File \\192.168.0.3\scripts$\Get-CompInfo.ps1

#
# PowerShell Session Configuration
#
# Create a PowerShell session and use it for the duration of the script
./PSNotes-PSSession.ps1

# Invoke-Command can be used for running remote PowerShell commands in an open session
Invoke-Command -Session $PSSession -ScriptBlock {}

# Or for running remote PowerShell commands on a single server without creating a session
Invoke-Command -ComputerName $computerName -ScriptBlock {}

# See the following example for script usage
./PSNotes-PSSession.ps1 

# How to accept username and password from the CLI securely
$adminUser = Read-Host -Prompt "Enter the Administrator username" -AsSecureString
$adminPassword = Read-Host -Prompt "Enter the Administrator password" -AsSecureString
$adminUser
$adminPassword

# How to test if a path exists
Test-Path -Path 'C:\Foo'

#
# Windows Networking Configuration
#
# Get Windows Network Connection Profile and set them all to Private
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

#
# Windows Themes Configuration
#
# This hides the Taskbar search
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 0 -Type DWord -Force

# This enables Windows 10/11 Dark Mode for Apps and System
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

# This enables Windows 10/11 Light Mode for Apps and System
#Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 1
#Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 1

# This disables the Task View button on the taskbar
#Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ #not complete

#
# From the PowerShell Command Cheat Sheet
#
# Try, Catch, Finally (optional), The code below shows the syntax of the Try statement.
<#try {
    <statement list> -ErrorAction Stop 
}
catch [[<error type>][',' <error type>]*]{
    <statement list>
}
finally {
    <statement list>
}#> 

# Pipe out to Get-Member to find TypeName value of the Exception property and all methods and properties for objects
$Error[0].Exception | Get-Member

# How to download files with PowerShell
.\PSNotes-downloading-files.ps1

# How To Download an MSI and save it to local storage for installation later
Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.3.0-preview.7/PowerShell-7.3.0-preview.7-win-x64.msi" -OutFile ./PowerShell-7.3.0-preview.7-win-x64.msi

#
# Appx: How to import the module
#
# The Appx module is not supported on certain platforms. Attempting to use the module generates the following error: [Operation is not supported on this platform. (0x80131539)]
# To get the Appx module to load successfully, it is required to use the "-UseWindowsPowerShell" parameter
Import-Module Appx -UseWindowsPowerShell
# Loading the Appxmodule this way will return the following warning: WARNING: Module Appx is loaded in Windows PowerShell using WinPSCompatSession remoting session; please note that all input and output of commands from this module will be deserialized objects. If you want to load this module into PowerShell please use 'Import-Module -SkipEditionCheck' syntax.
# Import-Module Appx -SkipEditionCheck will also return the following error: [Operation is not supported on this platform. (0x80131539)]
#
# Appx: How to Get-AppxPackage
Get-AppxPackage Microsoft.GamingServices
Get-AppxPackage Microsoft.XboxApp
# Appx: How to Remove-AppxPackage
Get-AppxPackage Microsoft.GamingServices | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage

