# Step 3a: Check the WinRM TrustedHosts on the management system for the remote system(s) with Get-Item 
Get-Item WSMan:\localhost\Client\TrustedHosts 
# Step 3b: Add all trusted hostnames with Set-Item * or pulled from a list
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'
