# Steps required to run locally in order to enable and use PSRemoting
# Step 1: Setup Windows Adv Firewall. Run the PowerShell Set-NetFirewallRule cmdlet locally on the remote system to enable File and Print Sharing on the Private Firewall Zone
# Future use case: enable option to take user input and modify the zone and, or IP Scope.
Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Private

# Step 2: Setup Windows Admin Shares. Required for Workgroup (JumpCloud Directory) computers, enable the LocalAccountTokenFilterPolicy for access to admin$ shares
# Future use case: enable switch between Workgroup REGEDIT or Domain Kerberos
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d 1 /f