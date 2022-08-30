# Set the location to the script working repository
Set-Location -Path 'G:\My Drive\!_Work\Notes\PowerShell\'
# Declare the variable for the file to import the list of hostanmes or IP addresses
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"

#Write-Output "Reading hostnames..."
ForEach ($HostName in $HostNames){
    # Declare the variable for the remote file path for copying temp data, need to come back and clean this up
    $remoteFilePath = "\\$Hostname\C$\Users\Public\Downloads\"
    #$remoteFile = "\\$Hostname\C$\Users\Public\Downloads\winget-packages.json"    
    $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)
    Invoke-Command -Session $PSSession -ScriptBlock {
        #Write-Output "Check for Admin privs..."
        # Future use: If not admin, then whoami and quit if not admin
        [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'
        #Write-Output "Check installed PowerShell Version..."
        # Future use: Compare the installed version with the latest in Github and download the latest if not already installed        
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
        Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* -Name 'SemanticVersion'.SemanticVersion
        # Install PowerShell-preview directly from Github for the latest version
        Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression "& { 
            $(Invoke-RestMethod https://aka.ms/install-powershell.ps1)
        } -UseMSI -Preview"
    }        
    #
    # Install Media Player(s)
    Invoke-Command -Session $PSSession -ScriptBlock { 
        Set-Location -Path 'C:\Users\Public\Downloads'
        Invoke-WebRequest -Uri "https://github.com/mpc-hc/mpc-hc/releases/download/1.7.13/MPC-HC.1.7.13.x64.exe" -OutFile ".\MPC-HC.1.7.13.x64.exe"
        Start-Process -FilePath ".\MPC-HC.1.7.13.x64.exe" -Verb runAs -ArgumentList '/SP','/VERYSILENT','/NORESTART'
    }
    #
    # Break
    #
    # Step 8a: Install Choco and more apps from an elevated PowerShell session 
    Invoke-Command -Session $PSSession -ScriptBlock {
        Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing |
            Invoke-Expression choco install -y chocolateygui googlechrome lastpass grammarly winrar python3 treesizefree
    }
    # Step 8b: Install more apps using winget and a import file 
    Invoke-Command -Session $PSSession -ScriptBlock {
    Test-Path -Path C:\Users\Public\Downloads\winget-packages.json # Should return False
    }
    Copy-Item -Path .\winget-packages.json -Destination $remoteFilePath -ToSession $PSSession
    Invoke-Command -Session $PSSession -ScriptBlock { 
        Test-Path -Path C:\Users\Public\Downloads\winget-packages.json # Should now return True
    }
    Invoke-Command -Session $PSSession -ScriptBlock { Set-Location -Path 'C:\Users\Public\Downloads\' | winget import --import-file .\winget-packages.json --accept-package-agreements }    # Install one or more apps using an import file
    Invoke-Command -Session $PSSession -ScriptBlock { Remove-Item -Path C:\Users\Public\Downloads\winget-packages.json } # clean up the winget import file    
}

# How to download and install JumpCloud
Set-Location $env:temp | 
Invoke-Expression; Invoke-RestMethod -Method Get -URI https://raw.githubusercontent.com/TheJumpCloud/support/master/scripts/windows/InstallWindowsAgent.ps1 -OutFile InstallWindowsAgent.ps1 | 
Invoke-Expression; ./InstallWindowsAgent.ps1 -JumpCloudConnectKey "55f1f38910d7de9a6555fc16e3cb4bab64cff86d"    

# Step 9: Ask to Install or Skip Optional Themes over the network
#.\Get-Themes.ps1

# Step 10: Close the session by removing it 
Remove-PSSession -Session $PSSession
