<#
.NOTES
    Script Name: 02-Get-PSRemoting.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 4/26/2023
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.

.SYNOPSIS
    Prompt the user to select a single host or provide a file containing a list of hostnames.
    Then use PsExec64.exe with the credentials of the user this script runs as to get the status of the WinRM service.
    If WinRM status != "running", then the script will attempt to enable PSRemoting.
    
.DESCRIPTION
    This is script checks for WinRM remoting on a single host or a list of hosts

.EXAMPLE
    .\02-Get-PSRemoting.ps1 <arguments>    
#>

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
            # Check PSRemoting status on remote host                        
            $WinRMStatus = ..\utilities\PsExec64.exe \\$HostName -h -s powershell "(Get-Service WinRM).Status"
            
            If ( $WinRMStatus -eq "Running” ) {
                Write-Output "WinRM is already set up to receive requests on $HostName."
            }
            Else {
                Write-Output "WinRM is not setup to recieve reqeusts on $HostName, and will be setup now."
                # Enable PSRemoting on\target if not already enabled
                ..\utilities\PsExec64.exe \\$HostName -h -s powershell "Enable-PSRemoting -SkipNetworkProfileCheck -Force"
            }            
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
                # Check PSRemoting status on remote host            
                $WinRMStatus = ..\utilities\PsExec64.exe \\$HostName -h -s powershell "(Get-Service WinRM).Status"
                If ( $WinRMStatus -eq "Running” ) {
                    Write-Output "WinRM is already set up to receive requests on $HostName."
                }
                Else {
                    Write-Output "WinRM is not setup to recieve reqeusts on $HostName, and will be setup now."
                    # Enable PSRemoting on\target if not already enabled
                    ..\utilities\PsExec64.exe \\$HostName -h -s powershell "Enable-PSRemoting -SkipNetworkProfileCheck -Force"
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
    }
    3 {
        Write-Host "Quitting script..."
        return
    }
    default {
        Write-Host "Invalid selection. Please enter 1, 2, or 3."
    }
}