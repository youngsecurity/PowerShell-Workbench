# Step 3a: Check the WinRM TrustedHosts on the management system for the remote system(s) with Get-Item 
Get-Item WSMan:\localhost\Client\TrustedHosts 
# Step 3b: Add all trusted hostnames with Set-Item * or pulled from a list
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'

# Step 4a: Set location for PsExec tool and check PSRemoting status on a single host
Set-Location -Path 'E:\!_Apps\!_Development Tools\SysinternalsSuite\'
.\PsExec.exe \\gorgatron -h -s powershell PSRemoting

# Step 4b: Enable PSRemoting on\target if not already enabled
.\PsExec.exe \\gorgatron -h -s powershell Enable-PSRemoting -Force

# Step 5a: Set the location to the script working directory and repository
Set-Location -Path 'G:\My Drive\!_Work\Notes\PowerShell\'

# Step 5b: Create a PowerShell session and use it for the duration of the script
$PSSession = New-PSSession -ComputerName 10.0.255.23 #-Credential (Get-Credential)      #Enable credentials for production

# Step 6: Check PowerShell Versions
Invoke-Command -Session $PSSession -ScriptBlock {Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* -Name 'SemanticVersion'.SemanticVersion}
Invoke-Command -Session $PSSession -ScriptBlock {$PSVersionTable}
    <#
    #$ps_version = $PSVersionTable.PSVersion.major
    if ( $ps_version -eq "2” ) {
        Write-Output "You are using Powershell 2.0"
    }
    elseif ( $ps_version -eq "5" ) {
        Write-Output "You are using Powershell 5"
    }
    elseif ( $ps_version -eq "7" ) {
        Write-Output "You are using Powershell 7"
    }
    #>

# Step 7: Install apps from winget
Invoke-Command -Session $PSSession -ScriptBlock {
    #winget import --import-file .\winget-packages.json --accept-package-agreements     # Install one or more apps using an import file
    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
    winget install --id Microsoft.WindowsTerminal; Microsoft.WindowsTerminal.Preview; #Microsoft.PowerShell.Preview; Microsoft.PowerShell     # Install one or more apps without an import file
}

# Step 8a: Install Choco and more apps from an elevated PowerShell Terminal
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
choco install chocolateygui notepadplusplus.install googlechrome lastpass grammarly winrar python3 treesizefree

# Step 8b: How To Download an MSI and save it to local storage for installation later
#Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.3.0-preview.7/PowerShell-7.3.0-preview.7-win-x64.msi" --OutFile ./PowerShell-7.3.0-preview.7-win-x64.msi

# Step 9: Ask to Install or Skip Optional Themes over the network
Invoke-Command -Session $PSSession -ScriptBlock {Get-ChildItem -Path "\\10.0.255.25\e\!_Art\Themes for Windows" -Filter *.themepack |
ForEach-Object {
    #Do something with $_.FullName like Start-Process -FilePath “myprogram.exe” -WorkingDirectory “C:\Users\admin\testfolder\experiments”
    Start-Process -FilePath $_.FullName -WorkingDirectory "\\10.0.255.25\e\!_Art\Themes for Windows"
    }
}

# How to download and install JumpCloud
Invoke-Command -Session $PSSession -ScriptBlock {
    Set-Location $env:temp | 
    Invoke-Expression; Invoke-RestMethod -Method Get -URI https://raw.githubusercontent.com/TheJumpCloud/support/master/scripts/windows/InstallWindowsAgent.ps1 -OutFile InstallWindowsAgent.ps1 | 
    Invoke-Expression; ./InstallWindowsAgent.ps1 -JumpCloudConnectKey "55f1f38910d7de9a6555fc16e3cb4bab64cff86d"    
}

# Step 10: Close the session by removing it 
Remove-PSSession -Session $PSSession

<# Used for running remote PowerShell commands in an open session
Invoke-Command -Session $PSSession -ScriptBlock {
    
}
#>
