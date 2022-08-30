# For non-AD workgroup systems only; Steps required to run locally in order to enable PSRemoting
# Get Windows Network Connection Profile and set them all to Private
# Set Windows Adv Firewall to enable File and Print Sharing on Private zone
# Set Windows Admin Shares required for Workgroup computers only
Try {
    Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
    Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Private
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d 1 /f
}
Catch {
    <#Do this if a terminating exception happens#>
    Write-Host $PSItem.Exception.Message -ForegroundColor Red    
}
Finally {
    $Error.Clear()
}