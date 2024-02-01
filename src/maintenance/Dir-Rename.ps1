<#
.NOTES
    Script Name: Dir-Rename.ps1
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
    .\Dir-Rename.ps1 <arguments>
    .\Dir-Rename.ps1 "E:\"
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
        $defaultDirectoryPath = "E:\!_Music"
        Write-Host "`nNo directory path was provided, using script default: `n$defaultDirectoryPath"
        Write-Host ""
        $directoryPath = $defaultDirectoryPath
    }
}

# Get a list of subdirectories (folders) in the specified directory
$folders = Get-ChildItem -Path $directoryPath -Directory

# Folder name prefix variable where it does not already exist
$folderPrefix = "!_"

# Iterate through each folder
foreach ($folder in $folders) {
    $folderName = $folder.Name
    $newFolderName = "$folderPrefix" + $folderName

    # Check if the folder name already starts with "!_"
    if (-not $folderName.StartsWith("$folderPrefix")) {
        # Rename the folder
        Rename-Item -Path $folder.FullName -NewName $newFolderName

        Write-Host "Renamed folder '$folderName' to '$newFolderName'"
    }
    else {
        Write-Host "Folder '$folderName' already has the correct format."
    }
}
