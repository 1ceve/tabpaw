# Security policy

## Supported versions

TabPaw is currently documentation and helper scripts under active development.
Security fixes are applied to the latest version on the default branch.

## Report a vulnerability

Do not open a public issue containing credentials, cookies, tunnel IDs, browser
profile data, private URLs, account identifiers, or exploitable details.

Use GitHub's private vulnerability reporting for this repository when it is
available. If private reporting is unavailable, open a minimal public issue
that asks the maintainer for a private contact channel and omit all sensitive
or exploitable information.

## Secrets that never belong in the repository

- OpenAI Runtime or Admin API keys
- Real tunnel IDs when they identify a private deployment
- Browser cookies, session databases, passwords, or recovery codes
- Chrome user-data directories
- Personal absolute paths and account names
- Diagnostic archives that have not been reviewed and redacted

Before every public release, run:

```bash
bash scripts/check-secrets.sh
git diff --cached
```

If a secret is committed, deleting it in a later commit is insufficient.
Revoke or rotate it immediately, then clean the Git history before publication.

## Operational guidance

- Use a dedicated Chrome profile.
- Restrict plugin access to trusted ChatGPT accounts and workspaces.
- Stop the tunnel when remote browser access is unwanted.
- Keep browser, Node.js, tunnel-client, and Chrome DevTools MCP updated.
- Personally enter credentials and one-time codes in the visible browser.
- Review actions that publish, send, purchase, delete, or change account state.
