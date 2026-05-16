#requires -version 7.0
<#
.SYNOPSIS
    Repairs Windows 11 "Other system tray icons" duplicate entries.

.DESCRIPTION
    Targets:
      HKCU:\Control Panel\NotifyIconSettings

    Behavior:
      - Backs up the NotifyIconSettings registry key.
      - Groups exact duplicate executable paths.
      - Groups common versioned install paths, such as:
          app-1.2.0
          app-1.3.0
          v1.2.0
          1.2.0
      - Chooses one winner per group.
      - Prefers currently running entries.
      - Then prefers existing executable paths.
      - Then prefers the newest parsed version.
      - Then prefers newest executable LastWriteTimeUtc.
      - If any duplicate was enabled with IsPromoted = 1, the winner is set to IsPromoted = 1.
      - Removes the losing duplicate registry entries.

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
$backupFile = Join-Path $backupDir "NotifyIconSettings-Before-Repair-$timestamp.reg"

function Normalize-PathString {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    return $Path.Trim().Replace('/', '\').ToLowerInvariant()
}

function Get-IsPromoted {
    param([object]$Value)

    if ($null -eq $Value) {
        return $false
    }

    return ([int]$Value -eq 1)
}

function Get-VersionFromSegment {
    param([string]$Segment)

    if ([string]::IsNullOrWhiteSpace($Segment)) {
        return $null
    }

    $clean = $Segment.ToLowerInvariant()

    # Handles app-1.2.3, v1.2.3, 1.2.3, 1.2.3.4
    if ($clean -match '^(?:app-|v)?(?<version>\d+(?:\.\d+){1,4})(?:[-_\.].*)?$') {
        try {
            return [version]$Matches.version
        }
        catch {
            return $null
        }
    }

    return $null
}

function Get-FamilyInfo {
    param([string]$ExecutablePath)

    $normalized = Normalize-PathString -Path $ExecutablePath

    if ([string]::IsNullOrWhiteSpace($normalized)) {
        return [PSCustomObject]@{
            FamilyKey = $null
            Version   = $null
            Rule      = 'NoExecutablePath'
        }
    }

    $parts = @($normalized -split '\\')

    if ($parts.Count -lt 2) {
        return [PSCustomObject]@{
            FamilyKey = $normalized
            Version   = $null
            Rule      = 'ExactPath'
        }
    }

    $versionIndex = $null
    $version = $null

    for ($i = $parts.Count - 2; $i -ge 0; $i--) {
        $candidateVersion = Get-VersionFromSegment -Segment $parts[$i]

        if ($null -ne $candidateVersion) {
            $versionIndex = $i
            $version = $candidateVersion
            break
        }
    }

    if ($null -ne $versionIndex) {
        $familyParts = @($parts)
        $familyParts[$versionIndex] = '{version}'
        $familyKey = $familyParts -join '\'

        return [PSCustomObject]@{
            FamilyKey = $familyKey
            Version   = $version
            Rule      = 'VersionedPath'
        }
    }

    return [PSCustomObject]@{
        FamilyKey = $normalized
        Version   = $null
        Rule      = 'ExactPath'
    }
}

function Get-ExecutableLastWriteTimeUtc {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $null
    }

    return (Get-Item -LiteralPath $Path).LastWriteTimeUtc
}

function Get-RunningExecutablePaths {
    $paths = New-Object 'System.Collections.Generic.HashSet[string]'

    foreach ($process in [System.Diagnostics.Process]::GetProcesses()) {
        try {
            $path = $process.MainModule.FileName
            $normalized = Normalize-PathString -Path $path

            if (-not [string]::IsNullOrWhiteSpace($normalized)) {
                [void]$paths.Add($normalized)
            }
        }
        catch {
            # Some protected/system processes do not allow MainModule access.
            # That is expected and not relevant to user tray apps.
        }
    }

    return $paths
}

function Compare-NullableVersion {
    param(
        [version]$A,
        [version]$B
    )

    if ($null -eq $A -and $null -eq $B) { return 0 }
    if ($null -eq $A) { return -1 }
    if ($null -eq $B) { return 1 }

    return $A.CompareTo($B)
}

function Get-Winner {
    param([object[]]$Entries)

    $winner = $null

    foreach ($entry in $Entries) {
        if ($null -eq $winner) {
            $winner = $entry
            continue
        }

        if ([int]$entry.IsRunning -ne [int]$winner.IsRunning) {
            if ($entry.IsRunning) { $winner = $entry }
            continue
        }

        if ([int]$entry.ExecutableExists -ne [int]$winner.ExecutableExists) {
            if ($entry.ExecutableExists) { $winner = $entry }
            continue
        }

        $versionCompare = Compare-NullableVersion -A $entry.Version -B $winner.Version
        if ($versionCompare -ne 0) {
            if ($versionCompare -gt 0) { $winner = $entry }
            continue
        }

        if ($null -ne $entry.LastWriteTimeUtc -or $null -ne $winner.LastWriteTimeUtc) {
            if ($null -eq $winner.LastWriteTimeUtc) {
                $winner = $entry
                continue
            }

            if ($null -ne $entry.LastWriteTimeUtc -and $entry.LastWriteTimeUtc -gt $winner.LastWriteTimeUtc) {
                $winner = $entry
                continue
            }
        }

        if ([int]$entry.IsPromoted -ne [int]$winner.IsPromoted) {
            if ($entry.IsPromoted) { $winner = $entry }
            continue
        }

        if ($entry.KeyName -lt $winner.KeyName) {
            $winner = $entry
        }
    }

    return $winner
}

Write-Host "Windows 11 tray icon Settings repair" -ForegroundColor Cyan
Write-Host "Target:"
Write-Host "  $notifyRegPath"
Write-Host ""

if (-not (Test-Path -LiteralPath $notifyPsPath)) {
    Write-Warning "NotifyIconSettings key was not found. Nothing to repair."
    return
}

$runningPaths = Get-RunningExecutablePaths

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

        $normalizedPath = Normalize-PathString -Path $executablePath
        $familyInfo = Get-FamilyInfo -ExecutablePath $executablePath
        $exists = $false

        if (-not [string]::IsNullOrWhiteSpace($executablePath)) {
            $exists = Test-Path -LiteralPath $executablePath -PathType Leaf
        }

        [PSCustomObject]@{
            KeyName          = $subkey.PSChildName
            RegistryPath     = $subkey.PSPath
            ExecutablePath   = $executablePath
            NormalizedPath   = $normalizedPath
            FamilyKey        = $familyInfo.FamilyKey
            FamilyRule       = $familyInfo.Rule
            Version          = $familyInfo.Version
            IsPromoted       = Get-IsPromoted -Value $isPromotedRaw
            IsPromotedRaw    = $isPromotedRaw
            ExecutableExists = $exists
            IsRunning        = if ($null -eq $normalizedPath) { $false } else { $runningPaths.Contains($normalizedPath) }
            LastWriteTimeUtc = Get-ExecutableLastWriteTimeUtc -Path $executablePath
        }
    }
)

if ($entries.Count -eq 0) {
    Write-Host "No tray icon entries found."
    return
}

$groups = @(
    $entries |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_.FamilyKey) } |
        Group-Object -Property FamilyKey |
        Where-Object { $_.Count -gt 1 }
)

if ($groups.Count -eq 0) {
    Write-Host "No duplicate tray icon families found." -ForegroundColor Green
    return
}

$plan = New-Object System.Collections.Generic.List[object]

foreach ($group in $groups) {
    $groupEntries = @($group.Group)
    $winner = Get-Winner -Entries $groupEntries
    $anyPromoted = [bool](@($groupEntries | Where-Object { $_.IsPromoted }).Count -gt 0)

    foreach ($entry in $groupEntries) {
        $action = if ($entry.KeyName -eq $winner.KeyName) {
            if ($anyPromoted -and -not $entry.IsPromoted) {
                'KeepAndEnable'
            }
            else {
                'Keep'
            }
        }
        else {
            'Remove'
        }

        $plan.Add([PSCustomObject]@{
            Action           = $action
            Enabled          = $entry.IsPromoted
            Running          = $entry.IsRunning
            Exists           = $entry.ExecutableExists
            Rule             = $entry.FamilyRule
            Version          = $entry.Version
            LastWriteTimeUtc = $entry.LastWriteTimeUtc
            ExecutablePath   = $entry.ExecutablePath
            KeyName          = $entry.KeyName
            RegistryPath     = $entry.RegistryPath
            FamilyKey        = $entry.FamilyKey
            WinnerKey        = $winner.KeyName
            AnyPromoted      = $anyPromoted
        })
    }
}

Write-Host "Duplicate family groups found: $($groups.Count)"
Write-Host "Entries to remove:             $(@($plan | Where-Object { $_.Action -eq 'Remove' }).Count)"
Write-Host "Entries to keep and enable:    $(@($plan | Where-Object { $_.Action -eq 'KeepAndEnable' }).Count)"
Write-Host ""

Write-Host "Repair plan:" -ForegroundColor Cyan

$plan |
    Sort-Object FamilyKey, Action, ExecutablePath |
    Format-Table `
        Action,
        Enabled,
        Running,
        Exists,
        Rule,
        Version,
        ExecutablePath `
        -AutoSize

if ($ReportOnly) {
    Write-Host ""
    Write-Host "ReportOnly mode was active. No changes were made." -ForegroundColor Yellow
    return
}

if (-not $NoBackup) {
    if ($WhatIfPreference) {
        Write-Host ""
        Write-Host "What if: Would export registry backup to:"
        Write-Host "  $backupFile"
    }
    else {
        if (-not (Test-Path -LiteralPath $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir | Out-Null
        }

        & reg.exe export $notifyRegPath $backupFile | Out-Null

        if ($LASTEXITCODE -ne 0) {
            throw "Registry backup failed. Aborting without changes."
        }

        Write-Host ""
        Write-Host "Backup created:"
        Write-Host "  $backupFile"
    }
}
else {
    Write-Warning "Backup skipped because -NoBackup was specified."
}

foreach ($item in @($plan | Where-Object { $_.Action -eq 'KeepAndEnable' })) {
    $target = "$($item.KeyName) [$($item.ExecutablePath)]"

    if ($PSCmdlet.ShouldProcess($target, "Set IsPromoted to 1 on winning tray icon entry")) {
        $props = Get-ItemProperty -LiteralPath $item.RegistryPath

        if ($props.PSObject.Properties.Name -contains 'IsPromoted') {
            Set-ItemProperty -LiteralPath $item.RegistryPath -Name 'IsPromoted' -Value 1
        }
        else {
            New-ItemProperty -LiteralPath $item.RegistryPath -Name 'IsPromoted' -Value 1 -PropertyType DWord | Out-Null
        }

        Write-Host "Enabled winner: $target" -ForegroundColor Green
    }
}

foreach ($item in @($plan | Where-Object { $_.Action -eq 'Remove' })) {
    $target = "$($item.KeyName) [$($item.ExecutablePath)]"

    if ($PSCmdlet.ShouldProcess($target, "Remove stale duplicate tray icon entry")) {
        Remove-Item -LiteralPath $item.RegistryPath -Recurse
        Write-Host "Removed duplicate: $target" -ForegroundColor Green
    }
}

Write-Host ""

if ($WhatIfPreference) {
    Write-Host "WhatIf mode was active. No changes were made." -ForegroundColor Yellow
}
else {
    Write-Host "Tray icon Settings repair completed." -ForegroundColor Green
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
    Write-Host "  .\Repair-Win11TrayIconSettings.ps1 -RestartExplorer"
}
