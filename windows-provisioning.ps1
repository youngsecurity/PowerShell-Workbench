
# Use this to install PowerShell and Windows Terminal Previews and other productivity apps
winget install --id Microsoft.Powershell.Preview --source winget
winget install --id Microsoft.WindowsTerminal --source winget
winget install --id Notepad++.Notepad++ --source winget

# From an elevated PowerShell 7-preview Terminal install choco
Set-ExecutionPolicy Bypass -Scope Process -Force; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco install chocolateygui googlechrome lastpass grammarly winrar python3 treesizefree

# Download an MSI and save it to local storage
#Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.3.0-preview.7/PowerShell-7.3.0-preview.7-win-x64.msi" --OutFile ./PowerShell-7.3.0-preview.7-win-x64.msi


# Install Themes
Get-ChildItem -Path "\\10.0.255.25\e\!_Art\Themes for Windows" -Filter *.themepack |

ForEach-Object {

    #Do something with $_.FullName
    #Like Start-Process -FilePath “myprogram.exe” -WorkingDirectory “C:\Users\admin\testfolder\experiments”
    Start-Process -FilePath $_.FullName -WorkingDirectory "\\10.0.255.25\e\!_Art\Themes for Windows"

}
