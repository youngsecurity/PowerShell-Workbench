# Declare the variable and content to import the list of hostanmes or IP addresses
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"
$SetPSLocation = Set-Location -Path "G:\My Drive\!_Work\Notes\PowerShell\"

$SetPSLocation
try {
    ForEach ($HostName in $HostNames) {    
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)
        Invoke-Command -Session $PSSession -ScriptBlock { 
            hostname
            #Get-WindowsOptionalFeature -Online -FeatureName *Hyper-v* |
            #    Where-Object { $_.State -eq "Enabled" }
        }    
    }    
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Host "An Error Occured" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}

