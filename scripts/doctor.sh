#!/usr/bin/env bash
set -euo pipefail

profile_name="${1:-tabpaw}"

missing=0
for required_command in tunnel-client node npm npx; do
  if ! command -v "${required_command}" >/dev/null 2>&1; then
    echo "Missing command: ${required_command}" >&2
    missing=1
  fi
done

if [[ "${missing}" -ne 0 ]]; then
  exit 1
fi

if [[ -n "${CONTROL_PLANE_API_KEY:-}" ]]; then
  echo "CONTROL_PLANE_API_KEY is set in this shell."
else
  echo "CONTROL_PLANE_API_KEY is not set in this shell."
  echo "This is fine only when your profile uses another supported secret reference."
fi

echo "tunnel-client: $(tunnel-client --version 2>&1 | head -n 1)"
echo "node: $(node --version)"
echo "npm: $(npm --version)"

exec tunnel-client doctor --profile "${profile_name}" --explain
