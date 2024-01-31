# Define the path to the directory containing the folders
$directoryPath = "E:\!_Music"

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
