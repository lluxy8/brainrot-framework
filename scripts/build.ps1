param(
    [string]$Output = "build/brainrot-framework.rbxlx"
)

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

    $outDir = Split-Path -Parent $Output
    if ($outDir -and -not (Test-Path $outDir)) {
        New-Item -ItemType Directory -Path $outDir | Out-Null
    }

    Write-Host ("Building place file -> {0}" -f $Output) -ForegroundColor Cyan
    & $rojo build default.project.json -o $Output
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }

    Write-Host "Build complete." -ForegroundColor Green
} finally {
    Pop-Location
}
