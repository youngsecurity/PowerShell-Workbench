# Read the file and select only the lines that match the Select-String
$MacAddresses = Get-Content -Path .\macs.txt | Select-String "(\w){4}"
<# Check the variable holds the right data selected, and send it to a new file
$MacAddresses
#>
Out-File -FilePath .\modified-macs.txt -InputObject $MacAddresses

# Read the first 11 characters of each line, then use regex replace to add the colon and update the working file
$StartOfMacAddress = Get-Content -path  .\modified-macs.txt | Select-String "(.{11})"
$MacAddress = $StartOfMacAddress -replace "(.{11})","`$1:"  
Out-File -FilePath .\modified-macs.txt -InputObject $MacAddress