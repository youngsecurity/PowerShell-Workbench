<#
.NOTES
    Script Name: 03-Get-PSWindows.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 5/9/2023
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.
.SYNOPSIS
.DESCRIPTION
.EXAMPLE
    .\03-Get-PSWindows.ps1 <arguments>
#>
$AdminPrivs = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'

Write-Host "Please choose one of the following options:"
Write-Host "1. Enter a single hostname"
Write-Host "2. Enter a file containing hostnames"
Write-Host "3. Quit"

$selection = Read-Host "Enter your selection (1, 2, or 3)"

switch ($selection) {
    1 {
        Write-Host "You selected Option One."
        $HostName = Read-Host "Enter a hostname"
        Write-Host "You entered the hostname: $HostName"
        try {            
            # Do this on each host
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
                            #winget upgrade
                            #winget source update
                            winget install Microsoft.PowerShell                            
                        }
                        catch {
                            Write-Host "An Error Occured" -ForegroundColor Red
                            Write-Host $PSItem.Exception.Message -ForegroundColor Red
                            $Error.Clear()                            
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
                        if ($PSCoreVersion[1] -ne "7.4.0-preview.4") {
                            Write-Host "You do not have the latest PowerShell Core 7 Preview Version installed. Your version is:" $PSCoreVersion[1]                            
                            Write-Host "Installing the latest PowerShell Core 7 Preview"
                            #winget upgrade
                            #winget source update
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
                            $Error.Clear()                            
                        }
                        finally {                            
                            Write-Host "You should now have both PowerShell Core Versions" $PSCoreVersion
                            Write-Host "Finished Installing PowerShell 7 Core"
                        }                    
                    }                    
                }                
            #}    
            } -ErrorAction Stop #Continue
            Remove-PSSession -Session $PSSession
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            #Do this if a terminating exception happens
            Write-Host "The $HostName was not found." -ForegroundColor Red    
        }
        catch {
            Write-Host $PSItem.Exception.Message -ForegroundColor Red
        }
        finally {
            #Do this after the try block regardless of whether an exception occurred or not
            $Error.Clear()
            Remove-PSSession -Session $PSSession
        }
    }
    2 {
        Write-Host "You selected Option Two."
        $filePath = Read-Host "Enter the file path containing hostnames"
        Write-Host "You entered the file path: $filePath"
        # Declare the variable and content to import the list of hostanmes or IP addresses
        $Hosts = Get-Content $filePath        
        try {
            ForEach ($HostName in $Hosts) {              
                # Do this on each host
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
                                #winget upgrade
                                #winget source update
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
                            if ($PSCoreVersion[1] -ne "7.4.0-preview.4") {
                                Write-Host "You do not have the latest PowerShell Core 7 Preview Version installed. Your version is:" $PSCoreVersion[1]                            
                                Write-Host "Installing the latest PowerShell Core 7 Preview"
                                #winget upgrade
                                #winget source update
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
                } -ErrorAction Stop #Continue
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            # Do this if a terminating exception happens
            Write-Host "An Error Occured" -ForegroundColor Red
            Write-Host "The $HostName was not found." -ForegroundColor Red    
        }
        catch {
            Write-Host "An Error Occured" -ForegroundColor Red
            Write-Host $PSItem.Exception.Message -ForegroundColor Red
        }
        finally {
            # Do this after the try block regardless of whether an exception occurred or not
            $Error.Clear()
            Remove-PSSession -Session $PSSession
        }
    }
    3 {
        Write-Host "Quitting script..."
        return
    }
    default {
        Write-Host "Invalid selection. Please enter 1, 2, or 3."
    }
}