# Declare the variable and content to import the list of hostanmes or IP addresses
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"
$SetPsExecLocation = Set-Location -Path 'E:\!_Apps\!_Development Tools\SysinternalsSuite\'

try {
    ForEach ($HostName in $HostNames) {
        # Set location for PsExec tool
        $SetPsExecLocation    
        # Check PSRemoting status on remote host            
        $WinRM_Status = .\PsExec.exe \\$HostName -h -s powershell "(Get-Service WinRM).Status"        
        If ( $WinRM_Status -eq "Running” ) {
            Write-Output "WinRM is already set up to receive requests on $HostName."
        }
        Else {
            Write-Output "WinRM is not setup to recieve reqeusts on $HostName, and will be setup now."
            # Enable PSRemoting on\target if not already enabled
            .\PsExec.exe \\$HostName -h -s powershell "Enable-PSRemoting -SkipNetworkProfileCheck -Force"
        }
    }
}
catch [System.Management.Automation.ItemNotFoundException] {
    <#Do this if a terminating exception happens#>
    Write-Host "The $HostName was not found." -ForegroundColor Red    
}
catch {
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
    $Error.Clear()
}