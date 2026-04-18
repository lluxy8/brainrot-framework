#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME="${1:-brainrot-framework}"
TARGET_FOLDER_NAME="${2:-brainrot-framework-current}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PACKAGES_ROOT="$DEMO_ROOT/Packages"
INDEX_ROOT="$PACKAGES_ROOT/_Index"
TARGET_ROOT="$PACKAGES_ROOT/$TARGET_FOLDER_NAME"

if [[ ! -d "$INDEX_ROOT" ]]; then
  echo "Packages/_Index is missing. Run 'wally install --project-path demos/brainrot-taxi' first." >&2
  exit 1
fi

best_version=""
best_package_root=""

shopt -s nullglob
for entry in "$INDEX_ROOT"/*_"$PACKAGE_NAME"@*; do
  [[ -d "$entry" ]] || continue

  package_root="$entry/$PACKAGE_NAME"
  [[ -d "$package_root" ]] || continue

  version="${entry##*@}"
  if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    continue
  fi

  if [[ -z "$best_version" ]]; then
    best_version="$version"
    best_package_root="$package_root"
    continue
  fi

  if [[ "$(printf '%s\n%s\n' "$best_version" "$version" | sort -V | tail -n1)" == "$version" ]]; then
    best_version="$version"
    best_package_root="$package_root"
  fi
done
shopt -u nullglob

if [[ -z "$best_package_root" ]]; then
  echo "No installed '$PACKAGE_NAME' package was found in Packages/_Index." >&2
  exit 1
fi

rm -rf "$TARGET_ROOT"
cp -R "$best_package_root" "$TARGET_ROOT"

echo "Synced $best_package_root -> $TARGET_ROOT"
