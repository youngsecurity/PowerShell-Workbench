<#
#Create a hashtable to hold the Mac Addresses
$MacAddresses = @{}

#Get all of the Mac Addresses. In this case, you are limiting your scope to a single text file
$files = Get-ChildItem ".\macs.txt"

#populate the hashtable
foreach ($file in $files) {
    #first, retrieve that same string, like in the first example. This time, also capture the information after the label in a capture group
    $StartMacAddress = select-string "(?<start>.{11})" $file
    $EndMacAddress = Select-String "(?<end>.{5}$)" $file
    #now, use the capture group to extract the serial number only. This is done using the special matches property. We also use the filename (without extension) as the index for the serial number
    #$MacAddresses[$file.basename] = $MacAddress.matches.groups[1].value    
    #$MacAddress.matches.groups[1].value    
    
    #$MacAddress = $MacAddresses -replace "$1",":"
    }
# write the output of the hashtable to the screen
#Write-Output ($MacAddresses)
Write-Output $EndMacAddress #| format-table
#>
$StartOfMacAddress = Get-Content -path  .\macs.txt | Select-String "(.{11})"
$EndOfMacAddress = Get-Content -path  .\macs.txt | Select-String "(.{5}$)"

$MacAddress = $StartOfMacAddress + $EndofMacAddress
$MacAddress
#$string = Get-Content -path  .\macs.txt | Select-String "(.)*"
#$StartOfMacAddress = Get-Content -path  .\macs.txt | Select-String "(.{11})"
#$StartMacAddress 
#append the year to the end of the serialnumber

#$MacAddress = $MacAddresses #-replace "(?<start>.{11}})","`$1-$EndOfMacAddresses"


<# $StartOfMacAddresses = Get-Content -path  .\macs.txt | Select-String "(?<start>.{11})"
$EndOfMacAddresses = Get-Content -path  .\macs.txt | Select-String "(?<end>.{5}$)"
#append the end of mac address to the end of the first 11 characters of the mac address, adding a colon
$MacAddress = $StartOfMacAddresses -replace "(?<start>.{11}})","`$1-$EndOfMacAddresses"
#$MacAddress = $StartOfMacAddresses 

write-output $MacAddress
 #>
<#
$MacAddress = Get-Content -path  .\macs.txt
#| Select-String -Pattern '([\w]){4,4}'
|
ForEach-Object {

    #Do something with $_.FullName
    #Like Start-Process -FilePath “myprogram.exe” -WorkingDirectory “C:\Users\admin\testfolder\experiments”
    #Start-Process -FilePath $_.FullName -WorkingDirectory "C:\Users\joseph.young\Downloads\Themes for Windows\todo"
    Select-String -Pattern '(.){11}' #| Where-Object -Matches '([\w]){4,4}'
    #$MacAddress -match '([\w]){4,4}'

    $MacAddress.Matches.Groups[0].Value
    #$MacAddress.Matches.Groups[1].Value

} 

#$Matches -split '.{11}' 

#$Result0 = $MacAddress.Matches.groups[0].value
#$Result1 = $MacAddress.Matches.Groups[1].Value

#$Result0
#$Result1


#:([\w]){1,2}
#>