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

    $stylua = Resolve-Tool "stylua"
    if (-not $stylua) {
        throw "Stylua not found. Run './scripts/install.ps1' first."
    }

    $targets = @("src", "test") | Where-Object { Test-Path $_ }
    if ($targets.Count -eq 0) {
        Write-Host "No src/ or test/ directory found to format." -ForegroundColor Yellow
        exit 0
    }

    Write-Host "Running StyLua..." -ForegroundColor Cyan
    & $stylua @targets
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }

    Write-Host "Formatting complete." -ForegroundColor Green
} finally {
    Pop-Location
}
