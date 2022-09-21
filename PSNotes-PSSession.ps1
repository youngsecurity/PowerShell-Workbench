$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell-Workbench\hostnames.txt"

try {
    ForEach ($HostName in $HostNames) {     
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)
        Invoke-Command -Session $PSSession -ScriptBlock { # some code            
            Write-Host `r
            Write-Host "hostname:" (hostname)
            Write-Host "whoami:" (whoami)
            
            Get-PSDrive 
            
        } -ErrorAction Stop # Error handling
    }    
}
catch {    
    Write-Host "An Error Occured" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    Write-Host `r`n
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}
