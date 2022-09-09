# Declare the variable and content to import the list of hostanmes or IP addresses
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"

ForEach ($HostName in $HostNames){
    # Step 9: Ask to Install or Skip Optional Themes over the network
    Copy-Item -Path "E:\!_Art\Themes for Windows\" -Recurse -Filter *.themepack -Destination "\\$Hostname\C$\Users\Public\Downloads\"
    Invoke-Command -Session $PSSession -ScriptBlock { 
        Set-Location -Path "C:\Users\Public\Downloads\Themes for Windows"
        Get-ChildItem -Path "C:\Users\Public\Downloads\Themes for Windows\" -Filter *.themepack |
            ForEach-Object {
                Start-Process -FilePath $_.FullName -WorkingDirectory "C:\Users\Public\Downloads\Themes for Windows" -Wait
            }                   
    }
}
# Close the session by removing it 
Remove-PSSession -Session $PSSession