#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"

patterns=(
  'sk-[A-Za-z0-9_-]{20,}'
  'github_pat_[A-Za-z0-9_]{20,}'
  'ghp_[A-Za-z0-9]{20,}'
  'tunnel_[0-9a-fA-F]{24,}'
  'BEGIN ([A-Z]+ )?PRIVATE KEY'
)

found=0

if command -v rg >/dev/null 2>&1; then
  for pattern in "${patterns[@]}"; do
    if rg --hidden --line-number \
      --glob '!.git/**' \
      --glob '!scripts/check-secrets.sh' \
      --regexp "${pattern}" .; then
      found=1
    fi
  done

  if rg --hidden --line-number \
    --glob '!.git/**' \
    --glob '!scripts/check-secrets.sh' \
    '/Users/[A-Za-z0-9._-]+/' . | grep -v '/Users/YOU/' ; then
    found=1
  fi
else
  echo "ripgrep is unavailable; running a reduced grep-based scan."
  if grep -RInE \
    --exclude-dir=.git \
    --exclude=check-secrets.sh \
    'sk-[A-Za-z0-9_-]{20,}|github_pat_[A-Za-z0-9_]{20,}|ghp_[A-Za-z0-9]{20,}|tunnel_[0-9a-fA-F]{24,}|BEGIN ([A-Z]+ )?PRIVATE KEY' .; then
    found=1
  fi
fi

if [[ "${found}" -ne 0 ]]; then
  echo "Potential secret or personal path detected." >&2
  exit 1
fi

echo "No obvious secrets or personal absolute paths detected."
