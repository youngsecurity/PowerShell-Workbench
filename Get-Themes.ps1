# Create a PowerShell session and use it for the duration of the script
# Future use: Switch between file pull or user input from the CLI

$PSSession = New-PSSession -ComputerName 10.0.255.23 #-Credential (Get-Credential)      #Enable credentials for production

# Step 9: Ask to Install or Skip Optional Themes over the network
Copy-Item -Path 'E:\!_Art\Themes for Windows\' -Recurse -Filter *.themepack -Destination '\\10.0.255.23\C$\Users\Public\Downloads\'
Invoke-Command -Session $PSSession -ScriptBlock { 
    Set-Location -Path 'C:\Users\Public\Downloads\Themes for Windows'
    Get-ChildItem -Path "C:\Users\Public\Downloads\Themes for Windows\" -Filter *.themepack |
        ForEach-Object {
            Start-Process -FilePath $_.FullName -WorkingDirectory "C:\Users\Public\Downloads\Themes for Windows" -Wait
        }                   
} 
# Close the session by removing it 
Remove-PSSession -Session $PSSession