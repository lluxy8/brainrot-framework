$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Push-Location $repoRoot
try {
    function Resolve-Tool([string]$ToolName) {
        $cmd = Get-Command $ToolName -ErrorAction SilentlyContinue
        if ($cmd) {
            return $cmd.Source
        }

        $candidate = Join-Path $env:USERPROFILE ".aftman\bin\$ToolName.exe"
        if (Test-Path $candidate) {
            return $candidate
        }

        return $null
    }

    $aftman = Get-Command aftman -ErrorAction SilentlyContinue
    if (-not $aftman) {
        throw "Aftman not found. Install Aftman and ensure it is available on PATH."
    }

    Write-Host "Installing toolchain with Aftman..." -ForegroundColor Cyan
    & $aftman.Source install
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }

    $wally = Resolve-Tool "wally"
    if (-not $wally) {
        throw "Wally not found after aftman install. Ensure '$env:USERPROFILE\.aftman\bin' is on PATH."
    }

    Write-Host "Installing Wally dependencies..." -ForegroundColor Cyan
    & $wally install
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }

    $folders = @(
        "src/Shared",
        "src/Server",
        "src/Client",
        "test"
    )

    foreach ($folder in $folders) {
        if (-not (Test-Path $folder)) {
            New-Item -ItemType Directory -Path $folder | Out-Null
        }
    }

    Write-Host "Setup complete." -ForegroundColor Green
} finally {
    Pop-Location
}
