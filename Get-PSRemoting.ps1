# Declare the variable and content to import the list of hostanmes or IP addresses
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"
$SetPsExecLocation = Set-Location -Path 'E:\!_Apps\!_Development Tools\SysinternalsSuite\'

# Step 4a: Set location for PsExec tool and check PSRemoting status on remote host
ForEach ($HostName in $HostNames){
    $SetPsExecLocation    
    #.\PsExec.exe \\$HostName -h -s powershell PSRemoting #check PSRemoting status
    #.\PsExec.exe \\$HostName -h -s powershell Enable-PSRemoting -SkipNetworkProfileCheck -Force
    .\PsExec.exe \\10.0.255.13 -h -s powershell Enable-PSRemoting -SkipNetworkProfileCheck -Force
# Step 4b: Enable PSRemoting on\target if not already enabled
}