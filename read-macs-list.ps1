$MacAddresses = Get-Content -path  .\macs.txt | Select-String -Pattern ':([\w]){2,2}\w'
$MacAddresses

$result = $MacAddresses.Matches.groups[0].value
$result
