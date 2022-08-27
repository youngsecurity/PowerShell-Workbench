# Setup the file to import the list of hostanmes or IP addresses
$computerName = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"
$computerName

# Step 5a: Set the location to the script working repository
Set-Location -Path 'G:\My Drive\!_Work\Notes\PowerShell\'
$PWD

# Step 5b: Create a PowerShell session and use it for the duration of the script
# Future use: Switch between file pull or user input from the CLI
$PSSession = New-PSSession -ComputerName $computerName #-Credential (Get-Credential)      #Enable credentials for production

# Check for Admin privs
# Future use: If not admin, then whoami and quit if not admin
Invoke-Command -Session $PSSession -ScriptBlock {
    [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'
}

# Step 6: Check PowerShell Versions
# Future use: Compare the installed version with the latest in Github and download the latest if not already installed
Invoke-Command -Session $PSSession -ScriptBlock {
    Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* -Name 'SemanticVersion'.SemanticVersion
}
#Invoke-Command -Session $PSSession -ScriptBlock {$PSVersionTable}

# Step 7: Install PowerShell-preview directly from Github for the latest version   
Invoke-Command -Session $PSSession -ScriptBlock {
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression "& { 
        $(Invoke-RestMethod https://aka.ms/install-powershell.ps1)
    } -UseMSI -Preview"
}     

# Step 8a: Install Choco and more apps from an elevated PowerShell session 
Invoke-Command -Session $PSSession -ScriptBlock {
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing |
        Invoke-Expression choco install -y chocolateygui googlechrome lastpass grammarly winrar python3 treesizefree
}

# Step 8b: Install more apps using winget and a import file 
$remoteFilePath = '\\10.0.255.23\C$\Users\Public\Downloads\'
#$remoteFile = '\\10.0.255.23\C$\Users\Public\Downloads\winget-packages.json'
Invoke-Command -Session $PSSession -ScriptBlock {
    Test-Path -Path C:\Users\Public\Downloads\winget-packages.json
}
Copy-Item -Path .\winget-packages.json -Destination $remoteFilePath -ToSession $PSSession
Invoke-Command -Session $PSSession -ScriptBlock { 
    Test-Path -Path C:\Users\Public\Downloads\winget-packages.json
}
Invoke-Command -Session $PSSession -ScriptBlock { Set-Location -Path 'C:\Users\Public\Downloads\' | winget import --import-file .\winget-packages.json --accept-package-agreements }    # Install one or more apps using an import file
Invoke-Command -Session $PSSession -ScriptBlock { Remove-Item -Path C:\Users\Public\Downloads\winget-packages.json }
Invoke-Command -Session $PSSession -ScriptBlock { 
    Set-Location -Path 'C:\Users\Public\Downloads'
    Invoke-WebRequest -Uri "https://github.com/mpc-hc/mpc-hc/releases/download/1.7.13/MPC-HC.1.7.13.x64.exe" -OutFile ".\MPC-HC.1.7.13.x64.exe"
    Start-Process -FilePath ".\MPC-HC.1.7.13.x64.exe" -Verb runAs -ArgumentList '/SP','/VERYSILENT','/NORESTART'
 }

# How to download and install JumpCloud
Set-Location $env:temp | 
Invoke-Expression; Invoke-RestMethod -Method Get -URI https://raw.githubusercontent.com/TheJumpCloud/support/master/scripts/windows/InstallWindowsAgent.ps1 -OutFile InstallWindowsAgent.ps1 | 
Invoke-Expression; ./InstallWindowsAgent.ps1 -JumpCloudConnectKey "55f1f38910d7de9a6555fc16e3cb4bab64cff86d"    

# Step 9: Ask to Install or Skip Optional Themes over the network
.\Get-Themes.ps1

# Step 10: Close the session by removing it 
Remove-PSSession -Session $PSSession



<#
$ps_version = $PSVersionTable.PSVersion.major
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
