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

# Define the base script path and ensure it's correct and accessible
$scriptPath = "F:\GitHub\PowerShell-Workbench\src\provisioning\00-CreateHyperVVM.ps1" # Update to your actual script path

# Define a generic script block for runspace execution
# Define the script block
$scriptBlock = {
    param(
        [string]$scriptPath,
        [string]$vmName,
        [string]$cpuCount,
        [string]$memorySize,
        [string]$vmDirectoryPath,
        [string]$vhdxPath,
        [string]$vhdxSize,
        [string]$isoPath,
        [string]$switchName
    )
    & $scriptPath $vmName $cpuCount $memorySize $vmDirectoryPath $vhdxPath $vhdxSize $isoPath $switchName
}

# Specify the full path to your script if not running from the same directory
$fullScriptPath = ".\00-CreateHyperVVM.ps1"

# Execute the script block with the provided parameters
& $scriptBlock $fullScriptPath 'carl-nix-02' '4' '4GB' 'F:\Hyper-V\Virtual Machines\' 'F:\Hyper-V\Virtual Machines\carl-nix-02\Virtual Hard Disks\carl-nix-02.vhdx' '15GB' 'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso' 'VM-TRUNK'

# Adjust these variables as needed for each VM
$params1 = @($scriptPath, 'carl-nix-02', '4', '4GB', 'F:\Hyper-V\Virtual Machines\', 'F:\Hyper-V\Virtual Machines\carl-nix-02\Virtual Hard Disks\carl-nix-02.vhdx', '15GB', 'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso', 'VM-TRUNK')
$params2 = @($scriptPath, 'carl-nix-03', '4', '4GB', 'F:\Hyper-V\Virtual Machines\', 'F:\Hyper-V\Virtual Machines\carl-nix-03\Virtual Hard Disks\carl-nix-03.vhdx', '15GB', 'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso', 'VM-TRUNK')

# Create and configure the runspaces
$Runspace1 = [runspacefactory]::CreateRunspace()
$Runspace1.Open()
$PowerShell1 = [powershell]::Create().AddScript($scriptBlock).AddArgument($params1)
$PowerShell1.Runspace = $Runspace1

$Runspace2 = [runspacefactory]::CreateRunspace()
$Runspace2.Open()
$PowerShell2 = [powershell]::Create().AddScript($scriptBlock).AddArgument($params2)
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
