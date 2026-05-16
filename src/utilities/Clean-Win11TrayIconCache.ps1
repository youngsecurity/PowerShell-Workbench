#requires -version 7.0
<#
.SYNOPSIS
    Deduplicates Windows 11 system tray icon Settings entries while preserving enabled icons.

.DESCRIPTION
    Targets:
      HKCU:\Control Panel\NotifyIconSettings

    For duplicate entries with the same ExecutablePath:
      - Prefer keeping an entry where IsPromoted = 1
      - Remove duplicate hidden entries
      - If multiple enabled duplicates exist, keep one enabled entry
      - Leave non-duplicates untouched

    This is safer than deleting the whole NotifyIconSettings cache.

.NOTES
    Run as the affected Windows user.
    Administrator rights are usually not required.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [switch]$RestartExplorer,
    [switch]$NoBackup,
    [switch]$ReportOnly
)

$ErrorActionPreference = 'Stop'

if (-not $IsWindows) {
    throw "This script only works on Windows."
}

$notifyPsPath = 'HKCU:\Control Panel\NotifyIconSettings'
$notifyRegPath = 'HKCU\Control Panel\NotifyIconSettings'

$backupDir = Join-Path $HOME 'Documents\TrayNotify-Backups'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupFile = Join-Path $backupDir "NotifyIconSettings-Before-Dedupe-$timestamp.reg"

function Get-NormalizedExecutablePath {
    param(
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    return $Path.Trim().ToLowerInvariant()
}

function Get-IsPromoted {
    param(
        [object]$Value
    )

    if ($null -eq $Value) {
        return $false
    }

    return ([int]$Value -eq 1)
}

Write-Host "Windows 11 tray icon duplicate cleanup" -ForegroundColor Cyan
Write-Host "Target:"
Write-Host "  $notifyRegPath"
Write-Host ""

if (-not (Test-Path -LiteralPath $notifyPsPath)) {
    Write-Warning "NotifyIconSettings key was not found. Nothing to clean."
    return
}

$entries = @(
    Get-ChildItem -LiteralPath $notifyPsPath | ForEach-Object {
        $subkey = $_
        $props = Get-ItemProperty -LiteralPath $subkey.PSPath

        $executablePath = $null
        $isPromotedRaw = $null

        if ($props.PSObject.Properties.Name -contains 'ExecutablePath') {
            $executablePath = [string]$props.ExecutablePath
        }

        if ($props.PSObject.Properties.Name -contains 'IsPromoted') {
            $isPromotedRaw = $props.IsPromoted
        }

        [PSCustomObject]@{
            KeyName                = $subkey.PSChildName
            RegistryPath           = $subkey.PSPath
            ExecutablePath         = $executablePath
            NormalizedExecutablePath = Get-NormalizedExecutablePath -Path $executablePath
            IsPromoted             = Get-IsPromoted -Value $isPromotedRaw
            IsPromotedRaw          = $isPromotedRaw
            ExecutableExists       = if ([string]::IsNullOrWhiteSpace($executablePath)) { $null } else { Test-Path -LiteralPath $executablePath }
        }
    }
)

if ($entries.Count -eq 0) {
    Write-Host "No tray icon entries found."
    return
}

Write-Host "Found $($entries.Count) tray icon setting entrie(s)."
Write-Host ""

$duplicateGroups = @(
    $entries |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_.NormalizedExecutablePath) } |
        Group-Object -Property NormalizedExecutablePath |
        Where-Object { $_.Count -gt 1 }
)

if ($duplicateGroups.Count -eq 0) {
    Write-Host "No duplicate ExecutablePath groups found." -ForegroundColor Green
    return
}

$toKeep = New-Object System.Collections.Generic.List[object]
$toRemove = New-Object System.Collections.Generic.List[object]

foreach ($group in $duplicateGroups) {
    $groupEntries = @($group.Group)

    $promotedEntries = @($groupEntries | Where-Object { $_.IsPromoted })
    $hiddenEntries = @($groupEntries | Where-Object { -not $_.IsPromoted })

    if ($promotedEntries.Count -gt 0) {
        # Keep one promoted entry. Remove all hidden duplicates and extra promoted duplicates.
        $winner = $promotedEntries | Sort-Object KeyName | Select-Object -First 1
        $toKeep.Add($winner)

        foreach ($entry in $groupEntries) {
            if ($entry.KeyName -ne $winner.KeyName) {
                $toRemove.Add($entry)
            }
        }
    }
    else {
        # No enabled entry exists. Keep one hidden entry so the app still has a Settings entry.
        $winner = $groupEntries | Sort-Object KeyName | Select-Object -First 1
        $toKeep.Add($winner)

        foreach ($entry in $groupEntries) {
            if ($entry.KeyName -ne $winner.KeyName) {
                $toRemove.Add($entry)
            }
        }
    }
}

Write-Host "Duplicate groups found: $($duplicateGroups.Count)"
Write-Host "Entries to keep:       $($toKeep.Count)"
Write-Host "Entries to remove:     $($toRemove.Count)"
Write-Host ""

Write-Host "Planned removals:" -ForegroundColor Cyan

$toRemove |
    Sort-Object ExecutablePath, IsPromoted, KeyName |
    Format-Table `
        @{ Label = 'Enabled'; Expression = { $_.IsPromoted } },
        @{ Label = 'Exists'; Expression = { $_.ExecutableExists } },
        @{ Label = 'ExecutablePath'; Expression = { $_.ExecutablePath } },
        @{ Label = 'KeyName'; Expression = { $_.KeyName } } `
        -AutoSize

if ($ReportOnly) {
    Write-Host ""
    Write-Host "ReportOnly mode was active. No changes were made." -ForegroundColor Yellow
    return
}

if (-not $NoBackup) {
    if ($WhatIfPreference) {
        Write-Host "What if: Would export registry backup to:"
        Write-Host "  $backupFile"
        Write-Host ""
    }
    else {
        if (-not (Test-Path -LiteralPath $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir | Out-Null
        }

        & reg.exe export $notifyRegPath $backupFile /y | Out-Null

        if ($LASTEXITCODE -ne 0) {
            throw "Registry backup failed. Aborting without changes."
        }

        Write-Host "Backup created:"
        Write-Host "  $backupFile"
        Write-Host ""
    }
}
else {
    Write-Warning "Backup skipped because -NoBackup was specified."
    Write-Host ""
}

foreach ($entry in $toRemove) {
    $target = "$($entry.KeyName) [$($entry.ExecutablePath)]"

    if ($PSCmdlet.ShouldProcess($target, "Remove duplicate tray icon settings entry")) {
        Remove-Item -LiteralPath $entry.RegistryPath -Recurse
        Write-Host "Removed duplicate: $target" -ForegroundColor Green
    }
}

Write-Host ""

if ($WhatIfPreference) {
    Write-Host "WhatIf mode was active. No changes were made." -ForegroundColor Yellow
}
else {
    Write-Host "Duplicate cleanup completed." -ForegroundColor Green
}

if ($RestartExplorer) {
    Write-Host ""

    if ($PSCmdlet.ShouldProcess("Windows Explorer", "Restart shell process")) {
        Write-Host "Restarting Explorer..."

        $explorerProcesses = [System.Diagnostics.Process]::GetProcessesByName('explorer')

        foreach ($process in $explorerProcesses) {
            Stop-Process -Id $process.Id
        }

        Start-Sleep -Seconds 2
        Start-Process explorer.exe

        Write-Host "Explorer restarted." -ForegroundColor Green
    }
}
else {
    Write-Host ""
    Write-Host "Explorer was not restarted."
    Write-Host "To apply changes immediately, run with:"
    Write-Host "  .\Clean-Win11TrayIconDuplicates.ps1 -RestartExplorer"
}
