# Prompt for remote host name, credentials, and virtual machine name
$hostName = Read-Host "Enter the name or IP address of the remote host"
$cred = Get-Credential
$vmName = Read-Host "Enter the name of the virtual machine on the remote host"

# Get the virtual machine object on the remote host
$vm = Get-VM -ComputerName $hostName -Credential $cred -Name $vmName

# Create the checkpoint with a name and description
$checkpointName = "Checkpoint $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$checkpointDescription = "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
New-VMSnapshot -VM $vm -Name $checkpointName -Description $checkpointDescription