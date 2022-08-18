

Get-Content .\macs.txt |

ForEach-Object {

    Select-String -Pattern '([\w]){4,5}'

}

$MacAddresses


#$sb.Insert($MacAddresses) | Out-Null


$StrValue = "01:38:f9:9e7b:8d" -match '([\w]){4}'
#$StrValue.0
$StrValue
$Matches
$StrValue
($SplitValue = $StrValue -split '([\d\w]){3}')
$SplitValue

#($StrValue -split '([\w]){4}')

