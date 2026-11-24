#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixture="$(mktemp "${repo_root}/.tabpaw-secret-scan-test.XXXXXX")"
trap 'rm -f "${fixture}"' EXIT

fake_secret='sk-'
fake_secret+='TABPAW_FAKE_TOKEN_0123456789'
printf '%s\n' "${fake_secret}" > "${fixture}"

set +e
scan_output="$(bash "${repo_root}/scripts/check-secrets.sh" 2>&1)"
scan_status=$?
set -e

if [[ "${scan_status}" -ne 1 ]]; then
  echo "Expected the scanner to reject the fixture; got exit ${scan_status}." >&2
  exit 1
fi

if [[ "${scan_output}" == *"${fake_secret}"* ]]; then
  echo "The scanner exposed matching secret content." >&2
  exit 1
fi

if [[ "${scan_output}" != *"$(basename "${fixture}")"* ]]; then
  echo "The scanner did not report the fixture filename." >&2
  exit 1
fi

echo "Secret scanner reports filenames without exposing matching content."
