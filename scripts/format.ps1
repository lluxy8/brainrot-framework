Write-Host "Running StyLua..."

$stylua = ".aftman/bin/stylua.exe"

if (!(Test-Path $stylua)) {
    Write-Host "Stylua not found. Run 'aftman install' first."
    exit 1
}

& $stylua src test

Write-Host "Formatting complete."