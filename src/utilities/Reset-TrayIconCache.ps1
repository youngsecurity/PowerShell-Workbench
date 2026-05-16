#requires -version 7.0
<#
.SYNOPSIS
    Clears the Windows 11 system tray icon cache for the current user.

.DESCRIPTION
    Removes the per-user TrayNotify cache values that cause duplicate/stale
    entries under:

    Settings > Personalization > Taskbar > Other system tray icons

    The script backs up the registry key before making changes.

.NOTES
    Run as the affected user.
    Administrator rights are usually not required because this is HKCU.
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

$trayNotifyPath = 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify'
$trayNotifyRegPath = 'HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify'

$cacheValues = @(
    'IconStreams',
    'PastIconsStream'
)

Write-Host "Windows system tray icon cache cleanup" -ForegroundColor Cyan
Write-Host "Target registry key:"
Write-Host "  $trayNotifyRegPath"
Write-Host ""

if (-not (Test-Path $trayNotifyPath)) {
    Write-Warning "TrayNotify registry key was not found. Nothing to clean."
    return
}

if (-not $NoBackup) {
    $backupDir = Join-Path $env:USERPROFILE 'Documents\TrayNotify-Backups'
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupFile = Join-Path $backupDir "TrayNotify-$timestamp.reg"

    Write-Host "Creating backup:"
    Write-Host "  $backupFile"

    & reg.exe export $trayNotifyRegPath $backupFile /y | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "Registry backup failed. Aborting without making changes."
    }

    Write-Host "Backup completed." -ForegroundColor Green
    Write-Host ""
}

$existingValues = Get-ItemProperty -Path $trayNotifyPath

foreach ($valueName in $cacheValues) {
    $valueExists = $existingValues.PSObject.Properties.Name -contains $valueName

    if ($valueExists) {
        if ($PSCmdlet.ShouldProcess("$trayNotifyRegPath\$valueName", "Remove registry value")) {
            Remove-ItemProperty -Path $trayNotifyPath -Name $valueName -Force
            Write-Host "Removed: $valueName" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Not found: $valueName"
    }
}

Write-Host ""
Write-Host "Tray icon cache values have been removed." -ForegroundColor Green

if ($RestartExplorer) {
    if ($PSCmdlet.ShouldProcess("Windows Explorer", "Restart shell process")) {
        Write-Host ""
        Write-Host "Restarting Windows Explorer..."

        Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force
        Start-Sleep -Seconds 2
        Start-Process explorer.exe

        Write-Host "Windows Explorer restarted." -ForegroundColor Green
    }
}
else {
    Write-Host ""
    Write-Host "Explorer was not restarted."
    Write-Host "To apply the cleanup now, run this script with:"
    Write-Host "  .\Reset-TrayIconCache.ps1 -RestartExplorer"
    Write-Host ""
    Write-Host "Or restart Windows Explorer manually from Task Manager."
}
