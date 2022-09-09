$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"
$SetPSLocation = Set-Location -Path "G:\My Drive\!_Work\Notes\PowerShell\"

$SetPSLocation
try {
    ForEach ($HostName in $HostNames) {    
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)
        Invoke-Command -Session $PSSession -ScriptBlock {
                hostname
                # Declare the variable for the remote file path for copying temp data, need to come back and clean this up
                $remoteFilePath = "\\$Hostname\C$\Users\Public\Downloads\"
                #$remoteFile = "\\$Hostname\C$\Users\Public\Downloads\winget-packages.json"
                #
                # Install more apps using winget and a import file             
                Test-Path -Path C:\Users\Public\Downloads\winget-packages.json # Should return False            
                Copy-Item -Path .\winget-packages.json -Destination $remoteFilePath -ToSession $PSSession
                Test-Path -Path C:\Users\Public\Downloads\winget-packages.json # Should now return True
                Set-Location -Path 'C:\Users\Public\Downloads\' | winget import --import-file .\winget-packages.json --accept-package-agreements    # Install one or more apps using an import file
                Remove-Item -Path C:\Users\Public\Downloads\winget-packages.json # clean up the winget import file
        } -ErrorAction Stop     
    }    
}
catch {    
    Write-Host "An Error Occured" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}

            #Get-WindowsOptionalFeature -Online -FeatureName *Hyper-v* |
            #    Where-Object { $_.State -eq "Enabled" }