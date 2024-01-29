<#
.NOTES
    Script Name: 00-CreateHyperVVM-async.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 1/29/2024
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.
.SYNOPSIS
    This script boilerplate will create resources async in Hyper-V on the local system.
.DESCRIPTION
    This async script calls the `00-CreateHyperVVM.ps1` script which requires eight arguments to be passed or defaults will be used.

.EXAMPLE
    .\00-CreateHyperVVM-async.ps1 <arguments>
#>

# Define the script block to run the external script with parameters
$scriptBlock = {
    param($scriptPath, $vmName, $cpu, $memory, $vmDirectoryPath, $vhdxPath, $vhdxSize, $isoPath, $switchName)
    & $scriptPath $vmName $cpu $memory $vmDirectoryPath $vhdxPath $vhdxSize $isoPath $switchName
}

# Start the first job
$argumentsJob1 = @(    
    ".\00-CreateHyperVVM.ps1", # $scriptPath
    'carl-nix-04', # $vmName   
    '4', # $cpu
    '4GB', # $memory
    'F:\Hyper-V\Virtual Machines\', # $vmDirectoryPath
    'F:\Hyper-V\Virtual Machines\carl-nix-04\Virtual Hard Disks\carl-nix-04.vhdx', # $vhdxPath
    '15GB', # $vhdxSize
    'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso', # $isoPath
    'VM-TRUNK' # $switchName
)
$job1 = Start-Job -ScriptBlock $scriptBlock -ArgumentList $argumentsJob1

# Start the second job
$argumentsJob2 = @(
    ".\00-CreateHyperVVM.ps1",
    'carl-nix-05',
    '4',
    '4GB',
    'F:\Hyper-V\Virtual Machines\',
    'F:\Hyper-V\Virtual Machines\carl-nix-05\Virtual Hard Disks\carl-nix-05.vhdx',
    '15GB',
    'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso',
    'VM-TRUNK'
)
$job2 = Start-Job -ScriptBlock $scriptBlock -ArgumentList $argumentsJob2

# Start the third job
$argumentsJob3 = @(
    ".\00-CreateHyperVVM.ps1",
    'carl-nix-06',
    '4',
    '4GB',
    'F:\Hyper-V\Virtual Machines\',
    'F:\Hyper-V\Virtual Machines\carl-nix-06\Virtual Hard Disks\carl-nix-06.vhdx',
    '15GB',
    'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso',
    'VM-TRUNK'
)
$job3 = Start-Job -ScriptBlock $scriptBlock -ArgumentList $argumentsJob3

# Start the fourth job
$argumentsJob4 = @(
    ".\00-CreateHyperVVM.ps1",
    'carl-nix-07',
    '4',
    '4GB',
    'F:\Hyper-V\Virtual Machines\',
    'F:\Hyper-V\Virtual Machines\carl-nix-07\Virtual Hard Disks\carl-nix-07.vhdx',
    '15GB',
    'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso',
    'VM-TRUNK'
)
$job4 = Start-Job -ScriptBlock $scriptBlock -ArgumentList $argumentsJob4

# Start the fifth job
$argumentsJob5 = @(
    ".\00-CreateHyperVVM.ps1",
    'carl-nix-08',
    '4',
    '4GB',
    'F:\Hyper-V\Virtual Machines\',
    'F:\Hyper-V\Virtual Machines\carl-nix-08\Virtual Hard Disks\carl-nix-08.vhdx',
    '15GB',
    'E:\!_Apps\!_Linux\!_Ubuntu\ubuntu-23.10-live-server-amd64.iso',
    'VM-TRUNK'
)
$job5 = Start-Job -ScriptBlock $scriptBlock -ArgumentList $argumentsJob5

# Optionally, wait for the jobs to finish and retrieve their results
Wait-Job $job1, $job2, $job3, $job4
$results1 = Receive-Job -Job $job1
$results2 = Receive-Job -Job $job2
$results3 = Receive-Job -Job $job3
$results4 = Receive-Job -Job $job4
$results5 = Receive-Job -Job $job5

# Output the results
Write-Output "Results from job 1: $results1"
Write-Output "Results from job 2: $results2"
Write-Output "Results from job 3: $results3"
Write-Output "Results from job 4: $results4"
Write-Output "Results from job 5: $results5"

# Clean up
Remove-Job -Job $job1
Remove-Job -Job $job2
Remove-Job -Job $job3
Remove-Job -Job $job4
Remove-Job -Job $job5

