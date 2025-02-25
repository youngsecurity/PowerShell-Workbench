# Prompt for remote host name, credentials, and VM name
# Enter the VM host
$hostName = Read-Host "Enter the name or IP address of a remote host, or use 'localhost' for creating checkpoints of VMs on the localhost"

# Enter credentials
#$cred = Get-Credential

if ($hostName -notmatch "localhost") {
    # List VMs on remote host
    Write-Host "VMs on remote host: $hostName"
    $remoteVMNames = Invoke-Command -ComputerName $hostName -ScriptBlock {Get-VM | Select-Object -ExpandProperty Name}
    Write-Output $remoteVMNames
} elseif ($hostName -match "localhost") {
    # List VMs on localhost
    Write-Host "VMs on localhost:"
    $localVMNames = Get-VM | Select-Object -ExpandProperty Name
    Write-Output $localVMNames
}

# Enter the VM name
$vmName = Read-Host "Enter the name of the virtual machine you would like to create a checkpoint for"

# Check if user prompt exists in the remote virtual machine names array
$remoteUserPromptExists = $remoteVMNames -like $vmName

# Check if user prompt exists in the local virtual machine names array
$localUserPromptExists = $localVMNames -like $vmName

# Execute different actions depending on the host where the user prompt exists
if ($remoteUserPromptExists) {
    # Execute action for remote host
    Write-Host "User prompt exists on the remote host."
    # Create the checkpoint on the remote host
    Write-Host "Creating the checkpoint for $vmName"
    $checkpointName = "$vmName $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')"
    Checkpoint-VM -Name $vmName -SnapshotName $checkpointName -ComputerName $hostName
} elseif ($localUserPromptExists) {
    # Execute action for local host
    Write-Host "User prompt exists on the local host."
    # Create the checkpoint on the localhost
    Write-Host "Creating the checkpoint for $vmName"
    $checkpointName = "$vmName $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')"
    Checkpoint-VM -Name $vmName -SnapshotName $checkpointName
} else {
    # Generate error message if user prompt does not exist in either host
    $errorMessage = "User prompt does not exist in any of the virtual machine names arrays."
    Write-Error $errorMessage
    # Handle the error
    # Exit with an error
    exit 1
    # If error handling is required to continue or try again
    #$errorAction = Read-Host "Do you want to continue? (Y/N)"
    #if ($errorAction -eq "Y") {
        # TODO: add your code to handle the error and continue
    #} else {
        # TODO: add your code to handle the error and exit
    #}
}