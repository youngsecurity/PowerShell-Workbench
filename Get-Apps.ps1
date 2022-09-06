        # Declare the variable for the remote file path for copying temp data, need to come back and clean this up
        $remoteFilePath = "\\$Hostname\C$\Users\Public\Downloads\"
        #$remoteFile = "\\$Hostname\C$\Users\Public\Downloads\winget-packages.json"    
        # Install Media Player(s)
        Invoke-Command -Session $PSSession -ScriptBlock { 
            Set-Location -Path 'C:\Users\Public\Downloads'
            Invoke-WebRequest -Uri "https://github.com/mpc-hc/mpc-hc/releases/download/1.7.13/MPC-HC.1.7.13.x64.exe" -OutFile ".\MPC-HC.1.7.13.x64.exe"
            Start-Process -FilePath ".\MPC-HC.1.7.13.x64.exe" -Verb runAs -ArgumentList '/SP','/VERYSILENT','/NORESTART'
        }
        #
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
