# Enable Hyper-V using PowerShell and Windows Client OS Programs and Features, this command is not supported on Server
# Future use case: Check OS client|server and proceed if client, if not perform command for Windows Server
#Invoke-Command -Session $PSSession -ScriptBlock { Get-WindowsOptionalFeature -Online -FeatureName *Hyper-v* | Where-Object { $_.State -eq "Enabled"  } }
#Invoke-Command -Session $PSSession -ScriptBlock { Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All }

Get-WindowsOptionalFeature -Online -FeatureName *Hyper-v* | Where-Object { $_.State -eq "Enabled"  }
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

