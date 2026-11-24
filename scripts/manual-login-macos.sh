#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This helper currently supports macOS only." >&2
  exit 1
fi

profile_dir="${TABPAW_CHROME_PROFILE_DIR:-$HOME/.cache/chrome-devtools-mcp/chrome-profile}"

if pgrep -f '[t]unnel-client.*run' >/dev/null 2>&1; then
  echo "A tunnel-client runtime appears to be running." >&2
  echo "Stop it before opening the dedicated Chrome profile manually." >&2
  exit 1
fi

mkdir -p "${profile_dir}"

echo "Opening the dedicated TabPaw Chrome profile:"
echo "  ${profile_dir}"
echo "Complete sign-in yourself, then fully quit Chrome before restarting TabPaw."

open -na "Google Chrome" --args \
  --user-data-dir="${profile_dir}" \
  --password-store=basic \
  --use-mock-keychain
