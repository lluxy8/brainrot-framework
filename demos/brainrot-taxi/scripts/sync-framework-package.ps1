param(
	[string]$PackageName = "brainrot-framework",
	[string]$TargetFolderName = "brainrot-framework-current"
)

$ErrorActionPreference = "Stop"

$demoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$packagesRoot = Join-Path $demoRoot "Packages"
$indexRoot = Join-Path $packagesRoot "_Index"
$targetRoot = Join-Path $packagesRoot $TargetFolderName

if (-not (Test-Path $indexRoot)) {
	throw "Packages/_Index is missing. Run 'wally install --project-path demos/brainrot-taxi' first."
}

function Parse-Version {
	param([string]$VersionText)

	if ($VersionText -match '^(\d+)\.(\d+)\.(\d+)') {
		return [pscustomobject]@{
			Major = [int]$Matches[1]
			Minor = [int]$Matches[2]
			Patch = [int]$Matches[3]
			Raw = $VersionText
		}
	}

	return $null
}

$candidates = @()
foreach ($entry in Get-ChildItem -Path $indexRoot -Directory) {
	if ($entry.Name -notmatch ("_{0}@" -f [regex]::Escape($PackageName))) {
		continue
	}

	$packageRoot = Join-Path $entry.FullName $PackageName
	if (-not (Test-Path $packageRoot)) {
		continue
	}

	$versionText = ($entry.Name -split "@")[-1]
	$parsedVersion = Parse-Version -VersionText $versionText
	if (-not $parsedVersion) {
		continue
	}

	$candidates += [pscustomobject]@{
		Version = $parsedVersion
		PackageRoot = $packageRoot
	}
}

if ($candidates.Count -eq 0) {
	throw "No installed '$PackageName' package was found in Packages/_Index."
}

$selected = $candidates | Sort-Object `
	@{ Expression = { $_.Version.Major }; Descending = $true }, `
	@{ Expression = { $_.Version.Minor }; Descending = $true }, `
	@{ Expression = { $_.Version.Patch }; Descending = $true } | Select-Object -First 1

if (Test-Path $targetRoot) {
	Remove-Item -Path $targetRoot -Recurse -Force
}

Copy-Item -Path $selected.PackageRoot -Destination $targetRoot -Recurse -Force

Write-Host ("Synced {0} -> {1}" -f $selected.PackageRoot, $targetRoot) -ForegroundColor Green
