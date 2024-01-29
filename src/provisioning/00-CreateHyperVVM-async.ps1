<#
.NOTES
    Script Name: 00-CreateHyperVVM-async.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 1/29/2024
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.
.SYNOPSIS
    This script boilerplate will create resources async in Hyper-V on the local system.
.DESCRIPTION
    Requires all eight arguments to be passed or defaults will be used.
.EXAMPLE
    .\00-CreateHyperVVM-async.ps1 <arguments>    
    .\00-CreateHyperVVM-async.ps1 'VMName' '4' '4GB' 'C:\Hyper-V\VMs\VMName' 'C:\Hyper-V\VMs\VMName\VMName.vhdx' '30GB' 'C:\Path\To\Your\ISOFile.iso' 'YourVirtualSwitchName'
#>

# Load the necessary assembly for runspaces
Add-Type -AssemblyName System.Management.Automation

# Create and configure the first runspace
$Runspace1 = [runspacefactory]::CreateRunspace()
$Runspace1.Open()
$PowerShell1 = [powershell]::Create().AddScript({
    # Your first script or command here    
    .\00-CreateHyperVVM.ps1 'carl-nix-02' '4' '4GB' 'F:\Hyper-V\Virtual Machines\' 'F:\Hyper-V\Virtual Machines\carl-nix-02\Virtual Hard Disks\carl-nix-02.vhdx' '15GB' 'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso' 'VM-TRUNK'
    Write-Output "Running runspace 1"
    Start-Sleep -Seconds 5
    Write-Output "Runspace 1 finished"
})
$PowerShell1.Runspace = $Runspace1

# Create and configure the second runspace
$Runspace2 = [runspacefactory]::CreateRunspace()
$Runspace2.Open()
$PowerShell2 = [powershell]::Create().AddScript({
    # Your second script or command here    
    .\00-CreateHyperVVM.ps1 'carl-nix-03' '4' '4GB' 'F:\Hyper-V\Virtual Machines\' 'F:\Hyper-V\Virtual Machines\carl-nix-03\Virtual Hard Disks\carl-nix-03.vhdx' '15GB' 'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso' 'VM-TRUNK'
    Write-Output "Running runspace 2"
    Start-Sleep -Seconds 5
    Write-Output "Runspace 2 finished"
})
$PowerShell2.Runspace = $Runspace2

# Start the runspaces asynchronously
$Async1 = $PowerShell1.BeginInvoke()
$Async2 = $PowerShell2.BeginInvoke()

# Wait for the runspaces to complete
$PowerShell1.EndInvoke($Async1)
$PowerShell2.EndInvoke($Async2)

# Cleanup
$PowerShell1.Dispose()
$Runspace1.Close()
$PowerShell2.Dispose()
$Runspace2.Close()
