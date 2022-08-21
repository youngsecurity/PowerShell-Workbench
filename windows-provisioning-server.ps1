# Step 3: Check the WinRM TrustedHosts on the management system with Get-Item and add all trusted hostnames with Set-Item *
Get-Item WSMan:\localhost\Client\TrustedHosts 
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'

# Step 4a: Check PSRemoting status on a single host
Set-Location -Path 'E:\!_Apps\!_Development Tools\SysinternalsSuite\'
.\PsExec.exe \\gorgatron -h -s powershell PSRemoting

# Step 4b: Enable PSRemoting on\target
.\PsExec.exe \\gorgatron -h -s powershell Enable-PSRemoting -Force

$PSSession = New-PSSession -ComputerName 10.0.255.23
Invoke-Command -Session $PSSession -ScriptBlock { }
Remove-PSSession -Session $PSSession
# Check the version of PowerShell Preview
#Invoke-Command -ComputerName gorgatron -ScriptBlock {Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* -Name 'SemanticVersion'.SemanticVersion'}

. 'E:\!_Apps\!_Development Tools\SysinternalsSuite\PsExec.exe' \\gorgatron -h -s powershell 
Invoke-Command -ComputerName 10.0.255.23 -ScriptBlock {$ps_version = $PSVersionTable.PSVersion.major
    if ( $ps_version -eq "2” ) {
        Write-Output "You are using Powershell 2.0"
    }
    elseif ( $ps_version -eq "5" ) {
        Write-Output "You are using Powershell 5"
    }
    elseif ( $ps_version -eq "7" ) {
        Write-Output "You are using Powershell 7"
    }
}
# Step 4: Install Apps remotely using winget
Invoke-Command -ComputerName 10.0.255.23 -ScriptBlock {Get-Host}
winget install --id Microsoft.Powershell.Preview --source winget
winget install --id Microsoft.WindowsTerminal --source winget
winget install --id Notepad++.Notepad++ --source winget

# Step 5: Install Choco and more Apps from an elevated PowerShell Terminal
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
choco install chocolateygui googlechrome lastpass grammarly winrar python3 treesizefree

# How To Download an MSI and save it to local storage
#Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.3.0-preview.7/PowerShell-7.3.0-preview.7-win-x64.msi" --OutFile ./PowerShell-7.3.0-preview.7-win-x64.msi

# How To Install Themes
Get-ChildItem -Path "\\10.0.255.25\e\!_Art\Themes for Windows" -Filter *.themepack |

ForEach-Object {

    #Do something with $_.FullName
    #Like Start-Process -FilePath “myprogram.exe” -WorkingDirectory “C:\Users\admin\testfolder\experiments”
    Start-Process -FilePath $_.FullName -WorkingDirectory "\\10.0.255.25\e\!_Art\Themes for Windows"

}

# How to download and install JumpCloud
Set-Location $env:temp | 
Invoke-Expression; Invoke-RestMethod -Method Get -URI https://raw.githubusercontent.com/TheJumpCloud/support/master/scripts/windows/InstallWindowsAgent.ps1 -OutFile InstallWindowsAgent.ps1 | 
Invoke-Expression; ./InstallWindowsAgent.ps1 -JumpCloudConnectKey "55f1f38910d7de9a6555fc16e3cb4bab64cff86d"