### Powershell Download File from URL
###
### Source URL
$url = "http://speed.transip.nl/10mb.bin"

## Destation file
$dest = "c:\temp\testfiles.bin"

## Download the file
Invoke-WebRequest -Uri $url -OutFile $dest

### Invoke-WebRequest will overwrite the local file if it already exists without any warning


### Authentication with Invoke-WebRequest
# URL and Destination
$url = "http://speed.transip.nl/10mb.bin"
$dest = "c:\temp\testfiles"

# Define username and password
$username = 'LazyUsrName'
$password = 'StrongPlainTextPasswd'

# Convert to SecureString
$secPassword = ConvertTo-SecureString $password -AsPlainText -Force

# Create Credential Object
$credObject = New-Object System.Management.Automation.PSCredential ($username, $secPassword)

# Download file
Invoke-WebRequest -Uri $url -OutFile $dest -Credential $credObject


### Download files faster with Start-BitsTransfer in PowerShell
# URL and Destination
$url = "http://speed.transip.nl/10mb.bin"
$dest = "c:\temp\testfiles"

# Download file
Start-BitsTransfer -Source $url -Destination $dest 

# Install MSI using PowerShell
Start-Process .\PowerShell-7.3.0-preview.7-win-x64.msi -ArgumentList "/quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISER_MANIFEST=1 /passive"

