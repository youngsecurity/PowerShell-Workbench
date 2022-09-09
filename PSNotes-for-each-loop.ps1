#Get something 
Get-ChildItem -Path "C:\Users\joseph.young\Downloads\Themes for Windows\todo" -Filter *.themepack |

ForEach-Object {

    #Do something with $_.FullName
    #Like Start-Process -FilePath “myprogram.exe” -WorkingDirectory “C:\Users\admin\testfolder\experiments”
    Start-Process -FilePath $_.FullName -WorkingDirectory "C:\Users\joseph.young\Downloads\Themes for Windows\todo"

}

# OR
$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell\hostnames.txt"
ForEach ($HostName in $HostNames){
Write-Output $HostName
}