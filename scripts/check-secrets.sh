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
  scan_with_rg() {
    local label="$1"
    local pattern="$2"
    local matches
    local status

    if matches="$(rg --hidden --files-with-matches \
      --glob '!.git/**' \
      --glob '!scripts/check-secrets.sh' \
      --regexp "${pattern}" .)"; then
      echo "${label}" >&2
      printf '%s\n' "${matches}" >&2
      found=1
    else
      status=$?
      if [[ "${status}" -ne 1 ]]; then
        echo "Secret scan failed while reading repository files." >&2
        exit "${status}"
      fi
    fi
  }

  for pattern in "${patterns[@]}"; do
    scan_with_rg "Potential secret found in:" "${pattern}"
  done

  scan_with_rg "Potential personal path found in:" '/Users/[A-Za-z0-9._-]+/'
else
  echo "ripgrep is unavailable; running a reduced grep-based scan."

  scan_with_grep() {
    local label="$1"
    local pattern="$2"
    local matches
    local status

    if matches="$(grep -RIlE \
      --exclude-dir=.git \
      --exclude=check-secrets.sh \
      "${pattern}" .)"; then
      echo "${label}" >&2
      printf '%s\n' "${matches}" >&2
      found=1
    else
      status=$?
      if [[ "${status}" -ne 1 ]]; then
        echo "Secret scan failed while reading repository files." >&2
        exit "${status}"
      fi
    fi
  }

  scan_with_grep \
    "Potential secret found in:" \
    'sk-[A-Za-z0-9_-]{20,}|github_pat_[A-Za-z0-9_]{20,}|ghp_[A-Za-z0-9]{20,}|tunnel_[0-9a-fA-F]{24,}|BEGIN ([A-Z]+ )?PRIVATE KEY'
  scan_with_grep \
    "Potential personal path found in:" \
    '/Users/[A-Za-z0-9._-]+/'
fi

if [[ "${found}" -ne 0 ]]; then
  echo "Potential secret or personal path detected." >&2
  exit 1
fi

echo "No obvious secrets or personal absolute paths detected."
