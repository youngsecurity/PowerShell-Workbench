<#
.NOTES
    Script Name: 00-RemoveHyperVVM.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 1/28/2024
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.
.SYNOPSIS
    This script boilerplate will remove resources in Hyper-V on the local system.
.DESCRIPTION
    
.EXAMPLE
    .\RemoveHyperVVM.ps1    
#>

# Ask the user for the VM name
$vmName = Read-Host "Enter the name of the Hyper-V VM to remove"

# Check if the VM exists
$vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue

if ($vm) {
    # Confirm with the user before removing the VM
    $confirmation = Read-Host "Are you sure you want to remove VM '$vmName'? (Y/N)"
    if ($confirmation -eq 'Y') {
        # Remove the VM
        Remove-VM -Name $vmName -Force
        Write-Host "VM '$vmName' has been removed."
    } else {
        Write-Host "VM removal canceled."
    }
} else {
    Write-Host "VM '$vmName' not found."
}
