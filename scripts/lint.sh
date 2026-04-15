#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

cache_root="$repo_root/.cache/localappdata"
mkdir -p "$cache_root"
export LOCALAPPDATA="$cache_root"

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

targets=()
[[ -d src ]] && targets+=("src")
[[ -d test ]] && targets+=("test")

if [[ ${#targets[@]} -eq 0 ]]; then
  echo "[Selene] No src/ or test/ directory found."
  exit 0
fi

selene="$(resolve_tool selene || true)"
if [[ -z "$selene" ]]; then
  echo "Selene not found. Run ./scripts/install.sh first."
  exit 1
fi

"$selene" --display-style Rich "${targets[@]}"
