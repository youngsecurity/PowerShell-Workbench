
# Create a PowerShell session and use it for the duration of the script
# Future use: Switch between file pull or user input from the CLI
$PSSession = New-PSSession -ComputerName 10.0.255.23 #-Credential (Get-Credential)      #Enable credentials for production
# Used for running remote PowerShell commands in an open session
Invoke-Command -Session $PSSession -ScriptBlock {}

# Used for running remote PowerShell commands on a single server or from a list of servers
Invoke-Command -ComputerName $computerName -ScriptBlock {}
# Teardown the session by removing it
Remove-PSSession -Session $PSSession

# How To Download an MSI and save it to local storage for installation later
Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.3.0-preview.7/PowerShell-7.3.0-preview.7-win-x64.msi" -OutFile ./PowerShell-7.3.0-preview.7-win-x64.msi


#Get Windows Network Connection Profile and set them all to Private
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# This hides the Taskbar search
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 0 -Type DWord -Force

# This enables Windows Dark Mode for Apps and System
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

# This enables Windows Light Mode for Apps and System
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 1
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 1

# This disables the Task View button on the taskbar
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ #not complete