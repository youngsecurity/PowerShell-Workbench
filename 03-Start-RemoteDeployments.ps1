# Set the location to the script working repository
Set-Location -Path 'G:\My Drive\!_Work\Notes\PowerShell\'
# Declare the variable for the file to import the list of hostanmes or IP addresses
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"
$AdminPrivs = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'

Write-Host "Reading hostnames..." -ForegroundColor Red
try {
    ForEach ($HostName in $HostNames) {
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)
        Invoke-Command -Session $PSSession -ScriptBlock {
            Start-Job -Name PowerShellUpdate -ScriptBlock {
                hostname
                Write-Host "Check for Admin privs..." -ForegroundColor Red
                # Future use: If not admin, then whoami and quit if not admin            
                if ( $AdminPrivs -eq "False") {
                    Write-Host "This script requires Administrator priviledges and will now exit." -ForegroundColor Red
                    Write-Host "Pleaase run the script again with Administrator priviledges." -ForegroundColor Red
                    Break
                }
                else {
                    $PSPath = Test-Path -Path "$env:ProgramFiles\PowerShell\7*"
                    if ($PSPath -eq "True") {
                        Write-Host "You have PowerShell 7 installed" -ForegroundColor Red
                        Write-Host "Checking PowerShell version..." -ForegroundColor Red
                        # Check the installed version of PowerShell
                        $PSCoreVersion = (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* -Name 'SemanticVersion').SemanticVersion
                        $PSCoreVersion
                        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                        Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } -AddExplorerContextMenu -EnablePSRemoting -Quiet -UseMSI"
                        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                        Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } -AddExplorerContextMenu -EnablePSRemoting -Preview -Quiet -UseMSI"
                    }
                    else {
                        Write-Host "$PSCoreVersion"
                        Write-Host "You do not have the latest PowerShell Core 7 Preview installed." -ForegroundColor Red
                        Write-Host "Installing PowerShell Core 7 Preview..." -ForegroundColor Red
                        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                        Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } -AddExplorerContextMenu -EnablePSRemoting -Quiet -UseMSI"
                        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                        Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } -AddExplorerContextMenu -EnablePSRemoting -Preview -Quiet -UseMSI"
                        #winget install Microsoft.PowerShell
                        #winget install Microsoft.PowerShell.Preview
                    }                                        
                }
            }        
        } -ErrorAction Continue      
    }
}
catch {
    Write-Host "An Error Occured" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    # Clear errors and close the session by removing it 
    $done = Invoke-Command -Session $PSSession -Command {
        Wait-Job -Name PowerShellUpdate            
    }
    $done.Count   
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}

# Step 9: Ask to Install or Skip Optional Themes over the network
#.\Get-Themes.ps1


