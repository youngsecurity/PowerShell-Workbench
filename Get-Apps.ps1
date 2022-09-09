        # Declare the variable for the remote file path for copying temp data, need to come back and clean this up
        $remoteFilePath = "\\$Hostname\C$\Users\Public\Downloads\"
        #$remoteFile = "\\$Hostname\C$\Users\Public\Downloads\winget-packages.json"    

        # Install more apps using winget and a import file 
        Invoke-Command -Session $PSSession -ScriptBlock {
        Test-Path -Path C:\Users\Public\Downloads\winget-packages.json # Should return False
        }
        Copy-Item -Path .\winget-packages.json -Destination $remoteFilePath -ToSession $PSSession
        Invoke-Command -Session $PSSession -ScriptBlock { 
            Test-Path -Path C:\Users\Public\Downloads\winget-packages.json # Should now return True
        }
        Invoke-Command -Session $PSSession -ScriptBlock { Set-Location -Path 'C:\Users\Public\Downloads\' | winget import --import-file .\winget-packages.json --accept-package-agreements }    # Install one or more apps using an import file
        Invoke-Command -Session $PSSession -ScriptBlock { Remove-Item -Path C:\Users\Public\Downloads\winget-packages.json } # clean up the winget import file    
