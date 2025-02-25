# Get Windows events and clear the logs
Get-WinEvent -ListLog * | ForEach-Object {
    [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog($_.LogName)
}