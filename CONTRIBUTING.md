# Contributing

Contributions that make TabPaw safer, easier to understand, or more portable
are welcome.

## Before opening a pull request

1. Keep every example generic and reproducible.
2. Never include a real API key, tunnel ID, account name, cookie, local profile,
   or personal absolute path.
3. Preserve the dedicated-profile security model.
4. Prefer links to primary upstream documentation.
5. Run:

   ```bash
   bash -n scripts/*.sh
   bash scripts/check-secrets.sh
   ```

6. Explain what you tested and on which operating system.

## Scope

Good contributions include:

- Clearer setup and recovery instructions
- Safer secret handling
- Tested support for another operating system
- Better diagnostics that do not expose credentials
- Documentation updates following upstream changes

Large changes should begin with an issue describing the use case and security
impact.

Unless explicitly stated otherwise, submitted contributions are licensed under
Apache License 2.0.
