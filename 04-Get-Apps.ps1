$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell-Workbench\hostnames.txt"
$localFilePath = "G:\My Drive\!_Work\Notes\PowerShell-Workbench\winget-packages.json"

try {
    ForEach ($HostName in $HostNames) {     
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)         
        $localFilePath = "G:\My Drive\!_Work\Notes\PowerShell-Workbench\winget-packages.json" 
        $remoteFilePath = "\\$HostName\C$\Users\Public\Downloads\"
        Write-Host "Trying to copy winget-packages.json..."
        Copy-Item -Path $localFilePath -Destination $remoteFilePath        
        Invoke-Command -Session $PSSession -ScriptBlock {
            Write-Host `r
            Write-Host "hostname:" (hostname)
            Write-Host "whoami:" (whoami)                                   
            # Install more apps using winget and a import file            
            Write-Host "Check if winget-packages.json exists (should return true)"
            Test-Path -Path "C:\Users\Public\Downloads\winget-packages.json"
            Set-Location -Path "C:\Users\Public\Downloads\" | winget import --import-file .\winget-packages.json --accept-package-agreements    # Install one or more apps using an import file
            Remove-Item -Path "C:\Users\Public\Downloads\winget-packages.json" # clean up the winget import file             
        } -ErrorAction Continue        
    }    
}
catch {    
    Write-Host "An Error Occured" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    Write-Host `r`n
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}

# Check for Hyper-V
#Get-WindowsOptionalFeature -Online -FeatureName *Hyper-v* | Where-Object { $_.State -eq "Enabled" }