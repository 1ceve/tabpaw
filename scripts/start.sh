#!/usr/bin/env bash
set -euo pipefail

profile_name="${1:-tabpaw}"

if ! command -v tunnel-client >/dev/null 2>&1; then
  echo "tunnel-client was not found. Install it with:" >&2
  echo "  brew install openai/tools/tunnel-client" >&2
  exit 1
fi

echo "Starting TabPaw with tunnel-client profile: ${profile_name}"
echo "Press Ctrl+C to stop it. Keep this Mac awake and online."

if command -v caffeinate >/dev/null 2>&1; then
  exec caffeinate -i tunnel-client run --profile "${profile_name}"
fi

exec tunnel-client run --profile "${profile_name}"
