# Troubleshooting

[简体中文](troubleshooting.zh-CN.md)

Run this first:

```bash
bash scripts/doctor.sh
```

Then open the local runtime UI at `http://127.0.0.1:8080/ui` when using the
example profile.

| Symptom | Likely cause | Action |
| --- | --- | --- |
| `CONTROL_PLANE_API_KEY` reference is invalid | The variable is absent from the current shell | Enter and export the Runtime API key in the same terminal, then rerun doctor |
| ChatGPT cannot find the plugin | Tunnel stopped, Mac slept, network failed, or the tunnel is not associated with this ChatGPT context | Wake the Mac, confirm network and readiness, verify tunnel associations, then restart |
| Chrome is visible but tools time out | The tunnel or MCP child disconnected | Stop the tunnel, fully quit the dedicated Chrome, and start again |
| Chrome says the profile is in use | Another Chrome process owns the same user-data directory | Fully quit every Chrome using that dedicated profile before restarting |
| A site signed out unexpectedly | A different profile was opened, or cookies expired | Use the documented default profile and sign in manually again |
| A site reports unusual traffic or presents CAPTCHA | The site detected automation | Stop the tunnel and use `manual-login-macos.sh`; do not repeatedly retry credentials through automation |
| Google rejects sign-in as unsafe | Automated Chrome was detected | Complete sign-in manually in the same dedicated profile, quit it, then restart TabPaw |
| Port `8080` is already in use | Another process has the health listener | Stop the other process or copy the profile and change `listen_addr` |
| `npx` is missing | Node.js/npm is unavailable to the tunnel process | Install Node.js LTS and ensure `npx` is on that process's `PATH` |

## Full restart sequence

1. Press `Ctrl+C` in the terminal running TabPaw.
2. Fully quit the dedicated Chrome.
3. Open a new terminal.
4. Restore `CONTROL_PLANE_API_KEY` if the profile uses the environment reference.
5. Run `bash scripts/doctor.sh`.
6. Run `bash scripts/start.sh`.
7. Retry a harmless, read-only page task.

## Inspect without exposing secrets

Safe checks:

```bash
test -n "${CONTROL_PLANE_API_KEY:-}" \
  && echo "CONTROL_PLANE_API_KEY is set" \
  || echo "CONTROL_PLANE_API_KEY is NOT set"

tunnel-client --version
node --version
npm --version
```

Do not paste raw keys, cookies, local browser databases, or complete diagnostic
archives into public issues. Redact tunnel IDs and personal paths from logs.

## Browser profile location

Chrome DevTools MCP's default stable-channel profile on macOS is:

```text
~/.cache/chrome-devtools-mcp/chrome-profile
```

It is reused between runs and can be owned by only one active browser process
at a time. Passing `--isolated` would create a temporary profile and therefore
would defeat TabPaw's persistent-session goal.

## Still stuck?

Check the upstream documentation before opening an issue:

- [Secure MCP Tunnel guide](https://developers.openai.com/api/docs/guides/secure-mcp-tunnels)
- [`openai/tunnel-client` troubleshooting](https://github.com/openai/tunnel-client/blob/master/docs/troubleshooting.md)
- [Chrome DevTools MCP troubleshooting](https://github.com/ChromeDevTools/chrome-devtools-mcp/blob/main/docs/troubleshooting.md)

When reporting a TabPaw documentation bug, include sanitized versions, the
failing step, the exact non-secret error, and what you expected to happen.
