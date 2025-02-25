# Enter the VM name
#$vmName = "ubuntu-22"
$vmName = Read-Host "Enter the VM Name"

# Enter the VM host
#$hostName = "QM2000M"
$hostName = Read-Host "Enter the hostname"

# Enter credentials
$cred = Get-Credential

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

# Example Pre-scripted, no user input required
Checkpoint-VM -Name "ubuntu-22" -SnapshotName "ubuntu-22 $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "QM2000M"
Checkpoint-VM -Name "steve" -SnapshotName "steve $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "QM2000M"
Checkpoint-VM -Name "dr-weird" -SnapshotName "dr-weird $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "QM2000M"
Checkpoint-VM -Name "oglethorpe" -SnapshotName "oglethorpe $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "carl"
Checkpoint-VM -Name "unos" -SnapshotName "unos $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "carl"
