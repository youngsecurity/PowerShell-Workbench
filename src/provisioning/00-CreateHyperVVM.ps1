<#
.NOTES
    Script Name: 00-CreateHyperVVM.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 1/28/2024
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.
.SYNOPSIS
    This script boilerplate will create resources in Hyper-V on the local system.
.DESCRIPTION
    
.EXAMPLE
    .\00-CreateHyperVVM.ps1 <arguments>        
    .\00-CreateHyperVVM.ps1 'VMName' '4' '4GB' 'C:\Hyper-V\VMs\VMName' 'C:\Hyper-V\VMs\VMName\VMName.vhdx' '30GB' 'C:\Path\To\Your\ISOFile.iso' 'YourVirtualSwitchName'
#>

# Function to validate and set default values for VM parameters
function Set-DefaultValue {
    param (
        [string]$value,
        [string]$defaultValue
    )
    if ([string]::IsNullOrWhiteSpace($value)) {
        return $defaultValue
    }
    return $value
}

# Check command line arguments
if ($args.Count -ne 8) {
    Write-Host "Usage: .\00-CreateHyperVVM.ps1 <VM Name> <vCPU Cores> <Memory> <VM Path> <VHDX Path> <VHDX Size> <ISO Path> <Virtual Switch Name>"
    Write-Host "Not all parameters provided. Exiting script."
    exit
}

# Assigning command line arguments to variables
$vmName, $vcpuCores, $vmMemory, $vmPath, $vhdxPath, $vhdxSize, $isoPath, $virtualSwitchName = $args

# Use default values if necessary (you can adjust these defaults as needed)
$vmName = Set-DefaultValue -value $vmName -defaultValue "YourVMName"
$vcpuCores = Set-DefaultValue -value $vcpuCores -defaultValue "4"
$vmMemory = Set-DefaultValue -value $vmMemory -defaultValue "4GB"
$vmPath = Set-DefaultValue -value $vmPath -defaultValue "C:\Hyper-V\VMs\$vmName"
$vhdxPath = Set-DefaultValue -value $vhdxPath -defaultValue "$vmPath\$vmName.vhdx"
$vhdxSize = Set-DefaultValue -value $vhdxSize -defaultValue "15GB"
$isoPath = Set-DefaultValue -value $isoPath -defaultValue "C:\Path\To\Your\ISOFile.iso"
$virtualSwitchName = Set-DefaultValue -value $virtualSwitchName -defaultValue "YourVirtualSwitchName"

# Create VM Directory
New-Item -Path $vmPath -ItemType Directory -Force

# Create the VM
New-VM -Name $vmName -MemoryStartupBytes $vmMemory -Path $vmPath -Generation 2

# Add Processor
Set-VMProcessor $vmName -Count $vcpuCores

# Add VM Memory
Set-VM -Name $vmName -MemoryStartupBytes $vmMemory
# Disable Secure Boot
Set-VMFirmware -VMName $vmName -EnableSecureBoot Off
# Enable Secure Boot
#Set-VMFirmware -VMName $vmName -EnableSecureBoot On

# Create a new VHDX
New-VHD -Path $vhdxPath -SizeBytes $vhdxSize -Dynamic

# Attach the VHDX to the VM
Add-VMHardDiskDrive -VMName $vmName -Path $vhdxPath

# Attach a DVD Drive to the VM and include a path to boot from the ISO
Add-VMDvdDrive -VMName $vmName -ControllerNumber 0 -ControllerLocation 1 -Path $isoPath

# Check that the DVD Drive was added to the VM
Get-VM -Name $vmName | Select-Object Name, DVDDrives | Format-List *

# Check the Path to the ISO
Get-VMDvdDrive -VMName $vmName | Select-Object Path

# Set a VM's first boot device to its DVD drive
Set-VMFirmware -VMName $vmName -FirstBootDevice (Get-VMDvdDrive -VMName $vmName)

# Check if the specified Virtual Switch exists
$virtualSwitch = Get-VMSwitch -Name $virtualSwitchName -ErrorAction SilentlyContinue

if ($virtualSwitch) {
    # If the Virtual Switch exists, connect the VM to the Virtual Switch
    Get-VMNetworkAdapter -VMName $vmName | Connect-VMNetworkAdapter -SwitchName $virtualSwitchName
    Write-Host "VM $vmName connected to the virtual switch $virtualSwitchName." -ForegroundColor Green
} else {
    Write-Host "Virtual Switch $virtualSwitchName not found. VM $vmName will not be connected to a network." -ForegroundColor Yellow
}

# Optional: Start the VM
Start-VM -Name $vmName

# Output message
Write-Host "VM $vmName created and configured successfully." -ForegroundColor Green

