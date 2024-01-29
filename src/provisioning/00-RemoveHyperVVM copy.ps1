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
    .\00-RemoveHyperVVM.ps1 <vmName>
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
if ($args.Count -eq 1) {
    $vmName = $args
} else {
    $vmName = Get-userInput -prompt "Enter the name of the Hyper-V VM to remove" -defaultValue "YourVMName"
}

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
