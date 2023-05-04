Get-Content -Path ".\src\maintenance\winget-packages.txt" | ForEach-Object {
    $update = $_
    try {
        winget upgrade --id $update
    }
    catch {
        Write-Host "Error installing update ${update}: $_"
    }
} 