Write-Host "Starting Rojo server..."

$rojo = ".aftman/bin/rojo.exe"

if (!(Test-Path $rojo)) {
    Write-Host "Rojo not found. Run 'aftman install' first."
    exit 1
}

& $rojo serve