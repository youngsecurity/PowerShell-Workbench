# PowerShell-Workbench <!-- omit from toc -->

## Table of Contents <!-- omit from toc -->

- [Prerequisites](#prerequisites)
- [Pre-Install PsExec Configuration](#pre-install-psexec-configuration)
  - [PsExec](#psexec)

### Prerequisites

- Windows PowerShell v5.1 - Should be preinstalled with Windows 10+.
- PsExec - [Download](https://learn.microsoft.com/en-us/sysinternals/downloads/psexec) PsExec to enable WinRM and PSRemoting.

### Pre-Install PsExec Configuration

1. Set the `-ExecutionPolicy` and, run a remote PowerShell v5 script on a remote system using PsExec.

```powershell
$hostName = "0.0.0.0"
psexec -s \\$hostName Powershell -ExecutionPolicy Bypass -File \\$hostName\scripts\Get-CompInfo.ps1
```

#### PsExec

[1] . Work in progress.
