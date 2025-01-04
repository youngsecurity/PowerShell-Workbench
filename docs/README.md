# PowerShell-Workbench () <!-- omit from toc -->

## Table of Contents <!-- omit from toc -->

- [Prerequisites](#prerequisites)
- [Pre-Install PsExec Configuration](#pre-install-psexec-configuration)
  - [PsExec](#psexec)

### Prerequisites

- PsExec - [https://learn.microsoft.com/en-us/sysinternals/downloads/psexec]
  - PsExec is required to enable WinRM and PSRemoting

### Pre-Install PsExec Configuration

1. Set the `-ExecutionPolicy` and, run a remote PowerShell v5 script on a remote system using PsExec.

```powershell
$hostName = "0.0.0.0"
psexec -s \\$hostName Powershell -ExecutionPolicy Bypass -File \\$hostName\scripts\Get-CompInfo.ps1
```

#### PsExec

[1] .
