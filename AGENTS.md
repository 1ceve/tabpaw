# Repository instructions

- Never add real credentials, tunnel IDs, cookies, account names, private URLs,
  browser profiles, or personal absolute paths.
- Keep `config/tabpaw.example.yaml` usable with placeholders.
- Treat `README.md`, `README.zh-CN.md`, and `docs/` as user-facing material.
- Prefer primary upstream documentation for technical claims.
- Keep helper scripts safe under `set -euo pipefail`.
- Do not delete, overwrite, or reset a user's existing tunnel profile.
- Run `bash -n scripts/*.sh` and `bash scripts/check-secrets.sh` before committing.
- When Codex or ChatGPT materially contributes to a commit, append exactly:
  `Co-authored-by: Codex <199175422+chatgpt-codex-connector[bot]@users.noreply.github.com>`
- Keep TabPaw independent; do not imply OpenAI or Google endorsement.
