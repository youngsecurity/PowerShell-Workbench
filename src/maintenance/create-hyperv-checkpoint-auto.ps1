# Prompt the user to enter the virtual machine name
$vmName = "ubuntu-22"
$ComputerName = "QM2000M"
# Get the virtual machine object
#$vm = Get-VM -Name $vmName
# Get the virtual machine object on the remote host
#$vm = Get-VM -ComputerName $hostName -Credential $cred -Name $vmName
$vm = Get-VM -ComputerName $ComputerName -Name $vmName

# Create the checkpoint with a name and description
$checkpointName = "Checkpoint $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$checkpointDescription = "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
New-VMSnapshot -VM $vm -Name $checkpointName -Description $checkpointDescription

# Create the checkpoint with a name and description
$checkpointName = "Checkpoint $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$checkpointDescription = "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
New-VMSnapshot -VM $vm -Name $checkpointName -Description $checkpointDescription



Checkpoint-VM -Name "ubuntu-22" -SnapshotName "ubuntu-22 $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "QM2000M"
Checkpoint-VM -Name "steve" -SnapshotName "steve $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "QM2000M"
Checkpoint-VM -Name "dr-weird" -SnapshotName "dr-weird $(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')" -ComputerName "QM2000M"
