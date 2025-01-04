param(
    [string]$ExecutablePath = "C:\path\to\your\program.exe",  # Default path to the executable
    [string]$RuleName = "BlockExecutableRule",               # Default rule name
    [string]$DisplayName = "Block Specific Executable"       # Default display name for the rule
)

# Check if the executable exists
if (-not (Test-Path $ExecutablePath)) {
    Write-Host "The specified executable path does not exist."
    exit 1
}

# Check if the rule already exists and remove it
$existingRule = Get-NetFirewallRule -DisplayName $DisplayName -ErrorAction SilentlyContinue
if ($existingRule) {
    Write-Host "Firewall rule already exists. Removing the existing rule..."
    Remove-NetFirewallRule -DisplayName $DisplayName
}

# Create a new firewall rule to block the executable
Write-Host "Creating a new firewall rule to block the executable..."
New-NetFirewallRule -DisplayName $DisplayName `
                    -Name $RuleName `
                    -Program $ExecutablePath `
                    -Action Block `
                    -Direction Outbound `
                    -Enabled True `
                    -Profile Any `
                    -Description "Blocks the specified executable outbound packets."

Write-Host "The rule has been successfully added to block the executable."
