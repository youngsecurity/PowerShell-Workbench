<#
.NOTES
    Script Name: Dir-Iterate.ps1
    Author: Joseph Young <joe@youngsecurity.net>
    Date: 1/31/2024
    Copyright: (c) Young Security Inc.
    Licensed under the MIT License.
.SYNOPSIS
    This script boilerplate will iterate through `Get-ChildItem -Directory`.
.DESCRIPTION
    This script can be used to iterate through a directory and manipulate any child directories.
    By default this script gets the Directory path one of three ways:
        - As an argument
        - From the CLI prompt
        - If no other argument is provided, the `$defaultDirectoryPath` stored in the script is used for automation
.EXAMPLE
    .\Dir-Iterate.ps1 <arguments>
    .\Dir-Iterate.ps1 "E:\"
#>

# Check if a command line argument was provided
if ($args.Count -gt 0) {
    # Use the provided argument as the directory path
    $directoryPath = $args[0]
}
else {
    # Prompt the user for the directory path
    $directoryPath = Read-Host "Enter the directory path"

    # If no input is provided, use the default value
    if ([string]::IsNullOrWhiteSpace($directoryPath)) {        
        $defaultDirectoryPath = "C:\"
        Write-Host "`nNo directory path was provided, using script default: `n$defaultDirectoryPath"
        Write-Host ""
        $directoryPath = $defaultDirectoryPath
    }
}

# Check if the provided or entered directory path exists
if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    Write-Host "Directory does not exist: $directoryPath"
    exit
}

# Get a list of subdirectories (folders) in the specified directory
$folders = Get-ChildItem -Path $directoryPath -Directory

# Iterate through each folder and do something
foreach ($folder in $folders) {        
    #Write-Host "This is the folder variable + FullName"
    $folderFullname = $folder.FullName
    Write-Host "$folderFullname"
    
    #Write-Host "This is the folderName variable"
    $folderName = $folder.Name    
    Write-Host "$folderName`n"    
}
