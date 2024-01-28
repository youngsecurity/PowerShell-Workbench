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
    .\00-CreateHyperVVM.ps1 'VMName' 'C:\Hyper-V\VMs\VMName' 'C:\Hyper-V\VMs\VMName\VMName.vhdx' 'C:\Path\To\Your\ISOFile.iso' 'YourVirtualSwitchName'
#>

# Function to get userInput with a prompt
function Get-userInput {
    param (
        [string]$prompt,
        [string]$defaultValue = ""
    )
    Write-Host ""$prompt": " -NoNewline
    $userInput = Read-Host
    if ([string]::IsNullOrWhiteSpace($userInput)) {
        return $defaultValue
    }
    return $userInput
}

# Check command line arguments and prompt for missing information
if ($args.Count -eq 5) {
    $vmName, $vmPath, $vhdxPath, $isoPath, $virtualSwitchName = $args
} else {
    $vmName = Get-userInput -prompt "Enter VM Name" -defaultValue "YourVMName"
    $vmPath = Get-userInput -prompt "Enter path to save the VM" -defaultValue "C:\Hyper-V\VMs\$vmName"
    # Ask for VHDX path only if not provided in command line arguments
    $vhdxPath = Get-userInput -prompt "Enter path to save the VM's VHDX" -defaultValue "C:\Hyper-V\VMs\$vmName\$vmName.vhdx"
    $isoPath = Get-userInput -prompt "Enter path to the ISO to boot from" -defaultValue "C:\Path\To\Your\ISOFile.iso"
    $virtualSwitchName = Get-userInput -prompt "Enter the name of your virtual switch" -defaultValue "YourVirtualSwitchName"
}

# Ensure the VHDX path is correctly formed based on the VM path if default is used
if ($vhdxPath -eq "C:\Hyper-V\VMs\$vmName\$vmName.vhdx") {
    $vhdxPath = Join-Path -Path $vmPath -ChildPath "$vmName.vhdx"
}

# Create VM Directory
New-Item -Path $vmPath -ItemType Directory -Force

# Create the VM
New-VM -Name $vmName -MemoryStartupBytes 8GB -Path $vmPath -Generation 2

# Add Processor
Set-VMProcessor $vmName -Count 4

# Create a new VHDX
New-VHD -Path $vhdxPath -SizeBytes 30GB -Dynamic

# Attach the VHDX to the VM
Add-VMHardDiskDrive -VMName $vmName -Path $vhdxPath

# Set the VM to boot from the ISO
Set-VMDvdDrive -VMName $vmName -Path $isoPath

# Check if the specified Virtual Switch exists
$virtualSwitch = Get-VMSwitch -Name $virtualSwitchName -ErrorAction SilentlyContinue

if ($virtualSwitch) {
    # If the Virtual Switch exists, connect the VM to the Virtual Switch
    Add-VMNetworkAdapter -VMName $vmName -SwitchName $virtualSwitchName
    Write-Host "VM $vmName connected to the virtual switch $virtualSwitchName." -ForegroundColor Green
} else {
    Write-Host "Virtual Switch $virtualSwitchName not found. VM $vmName will not be connected to a network." -ForegroundColor Yellow
}

# Optional: Start the VM
# Start-VM -Name $vmName

# Output message
Write-Host "VM $vmName created and configured successfully." -ForegroundColor Green
