$PSSession = New-PSSession -ComputerName 10.0.255.13 #-Credential (Get-Credential)

Invoke-Command -Session $PSSession -ScriptBlock { 
    Get-WindowsOptionalFeature -Online -FeatureName *Hyper-v* | Where-Object { $_.State -eq "Enabled"  }
 }
Remove-PSSession -Session $PSSession