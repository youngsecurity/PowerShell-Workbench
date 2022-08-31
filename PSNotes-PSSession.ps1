$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"
$SetPSLocation = Set-Location -Path "G:\My Drive\!_Work\Notes\PowerShell\"

$SetPSLocation
try {
    ForEach ($HostName in $HostNames) {    
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)
        Invoke-Command -Session $PSSession -ScriptBlock { 
            hostname
            # Check if the folders exist            
            $PSPath = Test-Path -Path "$env:ProgramFiles\PowerShell\7*"
                if ($PSPath -eq "True") {
                    Write-Host "You have PowerShell 7" -ForegroundColor Red                                       
                }
                else {
                    Write-Host "You do not have PowerShell 7 installed." -ForegroundColor Red
                    Write-Host "Installing PowerShell..." -ForegroundColor Red
                }
                $PSVersion = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* #| Select-Object SemanticVersion                    
                $PSVersion 
                if ( $PSVersion -eq "7.3.0.preview.7” ) {
                    Write-Host "You have PowerShell 7 Preview" -ForegroundColor Red
                }
                elseif ( $PSVersion -eq "7.2*” ) {
                    Write-Host "Your have PowerShell 7.2" -ForegroundColor Red
                }
            
                
            #$PSVersion = -join($PSVersionTable.PSVersion.Major,".",$PSVersionTable.PSVersion.Minor,".",$PSVersionTable.PSVersion.Patch,".",$PSVersionTable.PSVersion.PreReleaseLabel)            
            #Get-WindowsOptionalFeature -Online -FeatureName *Hyper-v* |
            #    Where-Object { $_.State -eq "Enabled" }
        } -ErrorAction Continue    
    }    
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Host "An Error Occured" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}

