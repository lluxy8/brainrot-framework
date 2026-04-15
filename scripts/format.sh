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

stylua="$(resolve_tool stylua || true)"
if [[ -z "$stylua" ]]; then
  echo "Stylua not found. Run ./scripts/install.sh first."
  exit 1
fi

targets=()
[[ -d src ]] && targets+=("src")
[[ -d test ]] && targets+=("test")

if [[ ${#targets[@]} -eq 0 ]]; then
  echo "No src/ or test/ directory found to format."
  exit 0
fi

echo "Running StyLua..."
"$stylua" "${targets[@]}"
echo "Formatting complete."
