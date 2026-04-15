param(
  # Watch `src/` + `test/` for changes and re-run Selene.
  [switch]$Watch,

  # Debounce window to avoid re-linting repeatedly during rapid saves.
  [int]$DebounceMs = 350
)

$ErrorActionPreference = "Stop"

# Lints Luau/Lua files using Selene.
# Prefers a global `selene`; falls back to `aftman run selene`.

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Push-Location $repoRoot
try {
  $previousLocalAppData = $env:LOCALAPPDATA
  $repoLocalAppData = Join-Path $repoRoot ".cache\localappdata"
  if (-not (Test-Path $repoLocalAppData)) {
    New-Item -Path $repoLocalAppData -ItemType Directory | Out-Null
  }
  $env:LOCALAPPDATA = $repoLocalAppData

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

  $exe = Resolve-Tool "selene"
  $seleneArgs = @("--display-style", "Rich")

  if (-not $exe) {
    throw "Selene not found. Run './scripts/install.ps1' first."
  }

  function Get-LintFiles {
    return @(
      Get-ChildItem -Path @("src", "test") -Recurse -File -Include *.luau, *.lua -ErrorAction SilentlyContinue |
        ForEach-Object { $_.FullName }
    )
  }

  $script:lastRunAt = Get-Date "1970-01-01"
  $script:lastExitCode = 0
  function Invoke-Lint {
    $now = Get-Date
    if (($now - $script:lastRunAt).TotalMilliseconds -lt $DebounceMs) { return }
    $script:lastRunAt = $now

    $files = Get-LintFiles
    if ($files.Count -eq 0) {
      Write-Host "[Selene] No *.luau/*.lua files found under src/ or test/." -ForegroundColor Yellow
      return
    }

    Write-Host ("`n[Selene] Linting {0} file(s)..." -f $files.Count) -ForegroundColor Cyan
    try {
      & $exe @seleneArgs @files
      $script:lastExitCode = $LASTEXITCODE
      if ($LASTEXITCODE -ne 0) {
        Write-Host ("[Selene] Failed (exit {0})" -f $LASTEXITCODE) -ForegroundColor Red
      } else {
        Write-Host "[Selene] OK" -ForegroundColor Green
      }
    } catch {
      $script:lastExitCode = 1
      Write-Host ("[Selene] Error: {0}" -f $_) -ForegroundColor Red
    }
  }

  Invoke-Lint

  if (-not $Watch) {
    exit $script:lastExitCode
  }

  # Watch mode: rerun on changes under src/ and test/.
  $watchedRoots = @("src", "test") | ForEach-Object { Join-Path $repoRoot $_ }
  $watchers = @()
  $subscriptions = @()

  foreach ($root in $watchedRoots) {
    if (-not (Test-Path $root)) { continue }
    $w = New-Object IO.FileSystemWatcher
    $w.Path = $root
    $w.IncludeSubdirectories = $true
    $w.EnableRaisingEvents = $true
    $w.Filter = "*.*"
    $watchers += $w

    # Note: We intentionally do NOT run lint in the event Action scriptblock.
    # Output from native executables can get swallowed/redirected in event runspaces.
    $subscriptions += Register-ObjectEvent $w Changed
    $subscriptions += Register-ObjectEvent $w Created
    $subscriptions += Register-ObjectEvent $w Deleted
    $subscriptions += Register-ObjectEvent $w Renamed
  }

  Write-Host "[Selene] Watch mode: monitoring src/ and test/ (Ctrl+C to stop)..." -ForegroundColor Yellow

  try {
    while ($true) {
      $evt = Wait-Event -Timeout 1
      if ($null -eq $evt) { continue }

      $path = $evt.SourceEventArgs.FullPath
      Remove-Event -EventIdentifier $evt.EventIdentifier | Out-Null

      if ($path -notmatch '\.(lua|luau)$') { continue }
      Invoke-Lint
    }
  } finally {
    foreach ($s in $subscriptions) {
      try { Unregister-Event -SubscriptionId $s.Id -ErrorAction SilentlyContinue } catch {}
    }
    foreach ($w in $watchers) {
      try { $w.Dispose() } catch {}
    }
  }
} finally {
  if ($null -ne $previousLocalAppData -and $previousLocalAppData -ne "") {
    $env:LOCALAPPDATA = $previousLocalAppData
  } else {
    Remove-Item Env:LOCALAPPDATA -ErrorAction SilentlyContinue
  }
  Pop-Location
}
