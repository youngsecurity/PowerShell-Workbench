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

function Get-UserInput {
    param (
        [string]$prompt,
        [string]$defaultValue = ""
    )
    Write-Host "${prompt}: " -NoNewline    
    $userInput = Read-Host
    if ([string]::IsNullOrWhiteSpace($userInput)) {
        return $defaultValue
    }
    return $userInput
}

function Remove-VMs {
    param (
        [string[]]$vmNames
    )
    foreach ($vmName in $vmNames) {
        $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
        if ($vm) {
            # Confirm with the user before removing the VM
            $confirmation = Read-Host "Are you sure you want to remove VM '$vmName'? (Y/N)"
            if ($confirmation -eq 'Y') {
                # Remove the VM
                Remove-VM -Name $vmName -Force
                Write-Host "VM '$vmName' has been removed."
            } else {
                Write-Host "VM removal for '$vmName' canceled."
            }
        } else {
            Write-Host "VM '$vmName' not found."
        }
    }
}

# Check command line arguments and prompt for missing information
if ($args.Count -ge 1) {
    # Assume each argument is a VM name
    $vmNames = $args
} else {
    # Single VM name from user input; split by comma for multiple VMs
    $inputVmNames = Get-UserInput -prompt "Enter the name(s) of the Hyper-V VM(s) to remove (comma separated for multiple)" -defaultValue "YourVMName"
    $vmNames = $inputVmNames -split ',' | ForEach-Object { $_.Trim() }
}

Remove-VMs -vmNames $vmNames
