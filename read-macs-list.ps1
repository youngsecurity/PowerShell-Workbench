$MacAddress = Get-Content -path  .\macs.txt | Select-String -Pattern '([\w]){4,4}'

$MacAddress 


$Result0 = $MacAddress.Matches.groups[0].value
#$Result1 = $MacAddress.Matches.Groups[1].Value

$Result0
#$Result1


#:([\w]){1,2}
