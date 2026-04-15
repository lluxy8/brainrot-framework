#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v aftman >/dev/null 2>&1; then
  echo "Aftman not found. Install Aftman and ensure it is available on PATH."
  exit 1
fi

resolve_tool() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    command -v "$name"
    return 0
  fi

  local candidate="$HOME/.aftman/bin/$name"
  if [[ -x "$candidate" ]]; then
    echo "$candidate"
    return 0
  fi

  return 1
}

echo "Installing toolchain with Aftman..."
aftman install

wally="$(resolve_tool wally || true)"
if [[ -z "$wally" ]]; then
  echo "Wally not found after aftman install. Ensure ~/.aftman/bin is on PATH."
  exit 1
fi

echo "Installing Wally dependencies..."
"$wally" install

mkdir -p src/Shared src/Server src/Client test
echo "Setup complete."
