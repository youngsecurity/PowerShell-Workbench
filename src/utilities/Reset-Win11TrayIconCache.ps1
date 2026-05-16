#requires -version 7.0
<#
.SYNOPSIS
    Resets the Windows 11 "Other system tray icons" Settings cache.

.DESCRIPTION
    Backs up and removes the per-user Windows 11 tray icon settings cache:

      HKCU:\Control Panel\NotifyIconSettings

    This clears stale and duplicate entries from:
      Settings > Personalization > Taskbar > Other system tray icons

    Run as the affected user. Admin rights are usually not required.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [switch]$RestartExplorer,
    [switch]$NoBackup
)

$ErrorActionPreference = 'Stop'

if (-not $IsWindows) {
    throw "This script only works on Windows."
}

$modernPsPath = 'HKCU:\Control Panel\NotifyIconSettings'
$modernRegPath = 'HKCU\Control Panel\NotifyIconSettings'

$backupDir = Join-Path $HOME 'Documents\TrayNotify-Backups'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupFile = Join-Path $backupDir "NotifyIconSettings-Win11-$timestamp.reg"

Write-Host "Windows 11 tray icon Settings cache reset" -ForegroundColor Cyan
Write-Host "Target:"
Write-Host "  $modernRegPath"
Write-Host ""

if (-not (Test-Path -LiteralPath $modernPsPath)) {
    Write-Warning "NotifyIconSettings key was not found. Nothing to reset."
    return
}

$subkeys = @(Get-ChildItem -LiteralPath $modernPsPath)
$rootProps = Get-ItemProperty -LiteralPath $modernPsPath
$hasUiOrderList = $rootProps.PSObject.Properties.Name -contains 'UIOrderList'

Write-Host "Found $($subkeys.Count) tray icon cache subkey(s)."

if ($hasUiOrderList) {
    Write-Host "Found UIOrderList root value."
}

Write-Host ""

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

        & reg.exe export $modernRegPath $backupFile /y | Out-Null

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

if ($hasUiOrderList) {
    if ($PSCmdlet.ShouldProcess("$modernRegPath\UIOrderList", "Remove registry value")) {
        Remove-ItemProperty -LiteralPath $modernPsPath -Name 'UIOrderList'
        Write-Host "Removed: UIOrderList" -ForegroundColor Green
    }
}

foreach ($subkey in $subkeys) {
    $label = $subkey.PSChildName

    try {
        $props = Get-ItemProperty -LiteralPath $subkey.PSPath

        if ($props.PSObject.Properties.Name -contains 'ExecutablePath') {
            $label = "$($subkey.PSChildName) [$($props.ExecutablePath)]"
        }
    }
    catch {
        $label = $subkey.PSChildName
    }

    if ($PSCmdlet.ShouldProcess($label, "Remove tray icon cache entry")) {
        Remove-Item -LiteralPath $subkey.PSPath -Recurse
        Write-Host "Removed: $label" -ForegroundColor Green
    }
}

Write-Host ""

if ($WhatIfPreference) {
    Write-Host "WhatIf mode was active. No changes were made." -ForegroundColor Yellow
}
else {
    Write-Host "Windows 11 tray icon Settings cache reset completed." -ForegroundColor Green
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
    Write-Host "To apply the reset immediately, run:"
    Write-Host "  .\Reset-Win11TrayIconSettings.ps1 -RestartExplorer"
}
