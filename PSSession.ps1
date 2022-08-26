# Create a PowerShell session and use it for the duration of the script
# Future use: Switch between file pull or user input from the CLI
$PSSession = New-PSSession -ComputerName 10.0.255.23 #-Credential (Get-Credential)      #Enable credentials for production

Invoke-Command -Session $PSSession -ScriptBlock {
    
}

# Teardown the session by removing it
Remove-PSSession -Session $PSSession