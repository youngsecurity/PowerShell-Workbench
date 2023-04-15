# Enter the VM name
$vmName = "ubuntu-22"

# Enter the VM host
$hostName = "QM2000M"

# Enter credentials
$cred = Get-Credential

# Ask the user if the VM is local or remote, or scan for the $vmName on the localhost and find out
# Then get the virtual machine object on the localhost or the remote host
# Get the VM object on the localhost
$vmLocal = Get-VM -Name $vmName
# Get the VM object on the remote host
$vmRemote = Get-VM -ComputerName $hostName -Credential $cred -Name $vmName


# Create the checkpoint on the localhost
$checkpointName = "$vmName $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')"
Checkpoint-VM -VM $vmLocal -SnapshotName $checkpointName -ComputerName $hostName

# Create the checkpoint on the remote host
$checkpointName = "$vmName $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')"
Checkpoint-VM -VM $vmRemote -SnapshotName $checkpointName -ComputerName $hostName

# Pre-scripted, no user input required
Checkpoint-VM -Name "ubuntu-22" -SnapshotName "ubuntu-22 $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "QM2000M"
Checkpoint-VM -Name "steve" -SnapshotName "steve $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "QM2000M"
Checkpoint-VM -Name "dr-weird" -SnapshotName "dr-weird $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "QM2000M"
