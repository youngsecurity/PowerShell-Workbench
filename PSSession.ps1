# Declare the variable and content to import the list of hostanmes or IP addresses
$computerName = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"

$PSSession = New-PSSession -ComputerName $computerName #-Credential (Get-Credential)
    Invoke-Command -Session $PSSession -ScriptBlock { 
        hostname
        #Get-WindowsOptionalFeature -Online -FeatureName *Hyper-v* |
        #    Where-Object { $_.State -eq "Enabled" }
        }
Remove-PSSession -Session $PSSession