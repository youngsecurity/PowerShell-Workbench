<#
    1. Read a list of MAC Addresses
    2. Locate/Match/Select a pattern of 4, but not more than 4 characters in series 
    3. Split the matched/selected pattern in half
    4. Insert ":"
    5. Put the string together "ab:cd"

#>
using namespace System.Text

$sb = [StringBuilder]::new()

$MacAddresses = Get-Content .\macs.txt | Select-String -Pattern '([\w]){4,5}'
#$StrValue = $MacAddresses.Matches -split (":")
#$StrValue

#$sb.Append
$sb.Insert($MacAddresses) | Out-Null
$sb.ToString()