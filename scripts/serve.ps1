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

    $rojo = Resolve-Tool "rojo"
    if (-not $rojo) {
        throw "Rojo not found. Run './scripts/install.ps1' first."
    }

    Write-Host "Starting Rojo server..." -ForegroundColor Cyan
    & $rojo serve default.project.json
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
} finally {
    Pop-Location
}
