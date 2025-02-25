<#
.NOTES
    Script Name: 01-Set-LocalhostSecurity.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 5/8/26/2023
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.

.SYNOPSIS
    For non-AD workgroup systems only; Steps required to run locally in order to enable PSRemoting

.DESCRIPTION
    Get Windows Network Connection Profile and set them all to Private
    Set Windows Adv Firewall to enable File and Print Sharing on Private zone, which enables ICMP echo
    Set Windows Admin Shares required for Workgroup computers only, required for WinRM

.EXAMPLE
    .\01-Set-LocalhostSecurity.ps1 <arguments>    
#>


Try {
    Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
    Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Private
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d 1 /f
}
Catch {    
    Write-Host $PSItem.Exception.Message -ForegroundColor Red    
}
Finally {
    $Error.Clear()
}