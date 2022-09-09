# How to download and install JumpCloud
Set-Location $env:temp | 
Invoke-Expression; Invoke-RestMethod -Method Get -URI https://raw.githubusercontent.com/TheJumpCloud/support/master/scripts/windows/InstallWindowsAgent.ps1 -OutFile InstallWindowsAgent.ps1 | 
Invoke-Expression; ./InstallWindowsAgent.ps1 -JumpCloudConnectKey "55f1f38910d7de9a6555fc16e3cb4bab64cff86d"    
