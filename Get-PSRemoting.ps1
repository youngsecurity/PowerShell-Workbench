## Step 4a: Set location for PsExec tool and check PSRemoting status on a single host
Set-Location -Path 'E:\!_Apps\!_Development Tools\SysinternalsSuite\'
.\PsExec.exe \\gorgatron -h -s powershell PSRemoting


# Step 4b: Enable PSRemoting on\target if not already enabled
.\PsExec.exe \\gorgatron -h -s powershell Enable-PSRemoting -Force
