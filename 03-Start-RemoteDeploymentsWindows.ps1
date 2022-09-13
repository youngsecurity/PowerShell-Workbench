# Must be run from Windows Host connected to Google Drive
# Set the location to the script working repository
Set-Location -Path 'G:\My Drive\!_Work\Notes\PowerShell-Workbench\'
# Declare the variable for the file to import the list of hostanmes or IP addresses
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell-Workbench\hostnames.txt"
$AdminPrivs = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'

Write-Host "Reading hostnames..." -ForegroundColor Red
try {
    ForEach ($HostName in $HostNames) {
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)
        Invoke-Command -Session $PSSession -ScriptBlock {
            #Start-Job -Name PowerShellUpdate -ScriptBlock {                
                Write-Host `r`n
                Write-Host "hostname:" (hostname)
                Write-Host "whoami:" (whoami)
                Write-Host "Is the script running as Administrator?" -ForegroundColor Red                              
                if ( $AdminPrivs -eq "False") {
                    Write-Host "No, this script requires Administrator priviledges and will now exit." -ForegroundColor Red
                    Write-Host "Pleaase run the script again with Administrator priviledges." -ForegroundColor Red
                    Break
                }
                else {
                    Write-Host "Yes, we have Administrator Priviledges"
                    # Get-PowerShell
                    Write-Host "Testing PowerShell Core 7 path"
                    $PSPathCore = Test-Path -Path "$env:ProgramFiles\PowerShell\7"                    
                    if ($PSPathCore -eq "True") {                        
                        Write-Host "You have PowerShell 7 Core installed" -ForegroundColor Red
                        Write-Host "Checking PowerShell 7 Core version..." -ForegroundColor Red
                        $PSCoreVersion = (Get-ItemPropertyValue -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* -Name 'SemanticVersion')#.SemanticVersion                                            
                        Write-Host "You have PowerShell Core Version(s)" ($PSCoreVersion)
                    }
                    else {                                                
                        Write-Host "You do not have the latest PowerShell Core 7 installed." -ForegroundColor Red                        
                        try {
                            winget upgrade
                            winget source update
                            winget install Microsoft.PowerShell                            
                        }
                        catch {
                            Write-Host "An Error Occured" -ForegroundColor Red
                            Write-Host $PSItem.Exception.Message -ForegroundColor Red
                        }
                        finally {
                            $PSCoreVersion = (Get-ItemPropertyValue -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* -Name 'SemanticVersion')                            
                            Write-Host "Finished Installing PowerShell 7 Core"
                        }                    
                    }
                    $PSPathCorePreview = Test-Path -Path "$env:ProgramFiles\PowerShell\7-preview"       
                    if ($PSPathCorePreview -eq "True") {
                        Write-Host "You have PowerShell 7 Core Preview installed" -ForegroundColor Red
                        Write-Host "Checking PowerShell 7 Core Preview version..." -ForegroundColor Red
                        $PSCoreVersion = (Get-ItemPropertyValue -Path HKLM:\SOFTWARE\Microsoft\PowerShellCore\InstalledVersions\* -Name 'SemanticVersion')
                        Write-Host "You have PowerShell 7 Core Preview Version" ($PSCoreVersion[1])
                        if ($PSCoreVersion[1] -ne "7.3.0-preview.7") {
                            Write-Host "You do not have the latest PowerShell Core 7 Preview Version installed. Your version is:" $PSCoreVersion[1]                            
                            Write-Host "Installing the latest PowerShell Core 7 Preview"
                            winget upgrade
                            winget source update
                            winget install Microsoft.PowerShell.Preview
                        }
                        else {
                            Write-Host "You have the latest PowerShell Core 7 Preview"
                        }
                    }
                    else {
                        Write-Host "You do not have the latest PowerShell Core 7 Preview installed." -ForegroundColor Red                        
                        try {                            
                            winget install Microsoft.PowerShell.Preview                            
                        }
                        catch {
                            Write-Host "An Error Occured" -ForegroundColor Red
                            Write-Host $PSItem.Exception.Message -ForegroundColor Red
                        }
                        finally {                            
                            Write-Host "You should now have both PowerShell Core Versions" $PSCoreVersion
                            Write-Host "Finished Installing PowerShell 7 Core"
                        }                    
                    }                    
                }                
            #}    
        } -ErrorAction Continue      
    }
}
catch {
    Write-Host "An Error Occured" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    # Clear errors and close the session by removing it 
    #$done = Invoke-Command -Session $PSSession -Command {
        #Wait-Job -Name PowerShellUpdate            
    #}
    #$done.Count   
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}


