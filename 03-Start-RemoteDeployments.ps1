# Set the location to the script working repository
Set-Location -Path 'G:\My Drive\!_Work\Notes\PowerShell\'
# Declare the variable for the file to import the list of hostanmes or IP addresses
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"

Write-Host "Reading hostnames..." -ForegroundColor Red
try {
    ForEach ($HostName in $HostNames) {
        # Declare the variable for the remote file path for copying temp data, need to come back and clean this up
        $remoteFilePath = "\\$Hostname\C$\Users\Public\Downloads\"
        #$remoteFile = "\\$Hostname\C$\Users\Public\Downloads\winget-packages.json"    
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)
        Invoke-Command -Session $PSSession -ScriptBlock {
            Write-Host "Check for Admin privs..." -ForegroundColor Red
            # Future use: If not admin, then whoami and quit if not admin
            $AdminPrivs = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'
                if ( $AdminPrivs -eq "False") {
                    Write-Host "This script requires Administrator priviledges and will now exit." -ForegroundColor Red
                    Write-Host "Pleaase run the script again with Administrator priviledges." -ForegroundColor Red
                    Break
                }
                else {
                    Write-Host "Check installed PowerShell Version..." -ForegroundColor Red
                    # Future use: Compare the installed version with the latest in Github and download the latest if not already installed        
                    # Check if the folders exist $env:ProgramFiles\PowerShell\7
                    $PSPath = Test-Path -Path "$env:ProgramFiles\PowerShell\7*"
                    if ($PSPath -eq "True") {
                        Write-Host "You have PowerShell 7" -ForegroundColor Red
                        $PSVersion = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* | Select-Object SemanticVersion                    
                        #$PSVersion
                        if ( $PSVersion -contains "7.3.0.preview.7” ) {
                            Write-Host "You have the latest PowerShell 7" -ForegroundColor Red
                        }
                        elseif ( $PSVersion -contains "7.2*” ) {
                            Write-Host "Your are using PowerShell 7.2" -ForegroundColor Red
                        }
                    }
                    else {
                        Write-Host "You do not have PowerShell 7 installed."
                        Write-Host "Installing PowerShell..." -ForegroundColor Red
                    }
                }
            
            # Install PowerShell 7 and PowerShell 7-preview directly from Github for the latest version
            Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression "& { 
                $(Invoke-RestMethod https://aka.ms/install-powershell.ps1)
            } -AddToPath -AddExplorerContextMenu -EnablePSRemoting -UseMSI -Quiet -Preview"
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
}
catch {
    <#Do this if a terminating exception happens#>
}
finally {
    # Clear errors and close the session by removing it 
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}

# Step 9: Ask to Install or Skip Optional Themes over the network
#.\Get-Themes.ps1


