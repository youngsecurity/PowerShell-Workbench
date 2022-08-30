# Declare the variable and content to import the list of hostanmes or IP addresses
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"
$SetPsExecLocation = Set-Location -Path 'E:\!_Apps\!_Development Tools\SysinternalsSuite\'

try {
    # Set location for PsExec tool and check PSRemoting status on remote host
    ForEach ($HostName in $HostNames) {
        $SetPsExecLocation    
        #Test-WSMan -ComputerName $HostName
        .\PsExec.exe \\$HostName -h -s powershell Get-Service WinRM
        # Enable PSRemoting on\target if not already enabled
        .\PsExec.exe \\$HostName -h -s powershell Enable-PSRemoting -SkipNetworkProfileCheck -Force
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