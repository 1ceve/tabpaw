# macOS setup

This guide creates a dedicated Chrome profile reachable through a private
OpenAI Secure MCP Tunnel. Keep every real credential and identifier outside
the repository.

## 1. Install prerequisites

Install current Google Chrome and a Node.js LTS release, then verify:

```bash
node --version
npm --version
npx --version
```

Install the official tunnel client through OpenAI's Homebrew tap:

```bash
brew install openai/tools/tunnel-client
tunnel-client --version
tunnel-client help quickstart
```

Chrome DevTools MCP is invoked with `npx -y chrome-devtools-mcp@latest`, so a
separate global npm installation is unnecessary.

## 2. Prepare OpenAI access

You need:

1. A tunnel created in
   [Platform tunnel settings](https://platform.openai.com/settings/organization/tunnels).
2. A Runtime API key from
   [Platform API keys](https://platform.openai.com/settings/organization/api-keys).
3. **Tunnels Read + Use** for the identity behind that runtime key.
4. **Tunnels Read + Manage** as well if the same identity creates or edits the
   tunnel.
5. The tunnel associated with the ChatGPT workspace or personal account that
   will use the plugin.

Use a runtime key for the long-running client. Do not use an Admin API key.
For the exact Platform and permission steps, follow
[Create the Secure MCP Tunnel](create-tunnel.md), then
[Create the Runtime API key](create-runtime-api-key.md).

## 3. Create a local profile

Clone this repository and enter its directory:

```bash
git clone https://github.com/1ceve/tabpaw.git
cd tabpaw
```

Then copy the example profile:

```bash
mkdir -p "$HOME/.config/tunnel-client"
cp config/tabpaw.example.yaml "$HOME/.config/tunnel-client/tabpaw.yaml"
chmod 600 "$HOME/.config/tunnel-client/tabpaw.yaml"
```

Edit the copied file and replace only the tunnel ID placeholder. Do not put the
API key directly in YAML.

The example uses:

```yaml
api_key: "env:CONTROL_PLANE_API_KEY"
```

For a foreground session, enter the key without putting it in shell history:

```bash
read -s CONTROL_PLANE_API_KEY
export CONTROL_PLANE_API_KEY
echo
```

For an OS-managed service, follow the upstream tunnel-client guidance and use
a permission-restricted `file:` reference instead of relying on an interactive
shell environment.

## 4. Validate the runtime

```bash
bash scripts/doctor.sh tabpaw
```

The equivalent direct command is:

```bash
tunnel-client doctor --profile tabpaw --explain
```

Resolve every doctor error before creating the ChatGPT plugin.

## 5. Start TabPaw

```bash
bash scripts/start.sh tabpaw
```

This helper is optional. It checks for `tunnel-client` and then runs the direct
macOS command:

```bash
caffeinate -i tunnel-client run --profile tabpaw
```

`caffeinate -i` prevents idle system sleep while the process runs. It does not
normally prevent a MacBook from sleeping when its lid is closed.

The default local administration page is:

```text
http://127.0.0.1:8080/ui
```

Readiness endpoints include `/healthz` and `/readyz` on the same address.

Only one active `tunnel-client` should use a given tunnel ID with a supervised
stdio MCP command. Stop the old process before starting a replacement.

Chrome does not need to be open before TabPaw is used. Keep `tunnel-client`
running; Chrome DevTools MCP launches the dedicated Chrome automatically when
the first browser tool requires it.

## 6. Add the private plugin in ChatGPT

While the local runtime is healthy:

1. Open ChatGPT Settings > Plugins.
2. Add a custom MCP server.
3. Choose **Tunnel** as the connection.
4. Select the same tunnel or enter its ID when the UI allows it.
5. Name the private plugin `TabPaw` or another local name.
6. Review the discovered browser tools and keep access limited to trusted users.

The plugin can be used from supported ChatGPT surfaces where it is enabled.
Availability depends on plan, rollout, and workspace permissions.

## 7. Make a safe first call

Start with a public, read-only task such as:

> Open `https://example.com`, report the page title, and take no other action.

The first browser tool call should launch the visible dedicated Chrome profile.
Confirm that the page opens on your Mac and the result returns to ChatGPT.

## 8. Sign in safely

Do not send passwords, one-time codes, or recovery codes through chat. Enter
them yourself in the visible browser.

If a site blocks the automated browser during sign-in:

1. Stop `tunnel-client` with `Ctrl+C`.
2. Fully quit the dedicated Chrome.
3. Run `bash scripts/manual-login-macos.sh`.
4. Complete sign-in manually.
5. Fully quit Chrome again.
6. Restart with `bash scripts/start.sh`.

The helper opens the same default Chrome DevTools MCP profile at:

```text
~/.cache/chrome-devtools-mcp/chrome-profile
```

The profile persists between normal runs. Never commit, upload, or share it.

## 9. Stop and revoke

- Press `Ctrl+C` to stop a foreground tunnel runtime.
- Quit the dedicated Chrome if it remains open.
- Revoke the Runtime API key in Platform if it may have leaked.
- Remove or disable the private ChatGPT plugin if access should end.
- Clear or delete the dedicated Chrome profile if its website sessions should
  be destroyed.

Deleting a Chrome profile is destructive. Back up anything intentionally kept
there before removing it.
