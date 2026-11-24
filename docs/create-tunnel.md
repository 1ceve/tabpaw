# Create the Secure MCP Tunnel

[简体中文](create-tunnel.zh-CN.md)

A tunnel is an OpenAI Platform connection record. ChatGPT and the local
`tunnel-client` must use the same `tunnel_id` to reach each other.

This guide uses the Platform web interface. Normal TabPaw setup does not need
an Admin API key.

## 1. Confirm access and permissions

Check that you can open:

- [Platform Tunnels](https://platform.openai.com/settings/organization/tunnels)
- [ChatGPT Plugins](https://chatgpt.com/#settings/Connectors)

In Platform, switch to the organization that will own the TabPaw tunnel.
Creating or editing a tunnel requires **Tunnels Read + Manage**. Running the
tunnel and selecting it in ChatGPT requires **Tunnels Read + Use**.

If Tunnels, Create tunnel, or Add custom MCP server is missing, the feature may
not be enabled for the account or the workspace administrator may not have
granted the required permission.

## 2. Create the tunnel in Platform

1. Open [Platform Tunnels](https://platform.openai.com/settings/organization/tunnels).
2. Select **Create tunnel**. The exact button text may change with UI updates.
3. Use a recognizable name such as `TabPaw Browser`.
4. Optionally enter `Visible Chrome bridge for ChatGPT` as the description.
5. Associate the tunnel with the ChatGPT workspace or personal space where
   TabPaw will be used. The page requires at least one available scope.
6. Confirm creation.

The workspace association matters. A tunnel can exist in Platform but remain
absent from ChatGPT when it is associated with the wrong workspace.

## 3. Save the tunnel ID

Open the new tunnel's details and copy the ID, which looks like:

```text
tunnel_<32-character-id>
```

That value is an example and cannot be used. Keep the real tunnel ID locally;
do not paste it into chat, screenshots, or GitHub. Allow about 25–30 seconds for
a new tunnel to become active.

## 4. Put it in the local TabPaw profile

Copy the example profile as described in the README:

```bash
mkdir -p "$HOME/.config/tunnel-client"
cp config/tabpaw.example.yaml "$HOME/.config/tunnel-client/tabpaw.yaml"
chmod 600 "$HOME/.config/tunnel-client/tabpaw.yaml"
```

Open the local file at:

```text
~/.config/tunnel-client/tabpaw.yaml
```

Replace only this placeholder:

```yaml
tunnel_id: "tunnel_REPLACE_WITH_YOUR_ID"
```

Keep the API key outside YAML and leave this line unchanged:

```yaml
api_key: "env:CONTROL_PLANE_API_KEY"
```

For the key steps, follow [Create the Runtime API key](create-runtime-api-key.md).

## 5. Diagnose and start

Enter the Runtime API key in the current terminal:

```bash
read -s CONTROL_PLANE_API_KEY
export CONTROL_PLANE_API_KEY
echo
```

From the cloned `tabpaw` directory, run:

```bash
bash scripts/doctor.sh
bash scripts/start.sh
```

Leave the second command running. Inspect the local status page at:

```text
http://127.0.0.1:8080/ui
```

Continue after the client is healthy, ready, and polling.

## 6. Select the same tunnel in ChatGPT

Complete this step in ChatGPT on the web:

1. Open **Plugins**.
2. Select the plus button, then **Add custom MCP server**.
3. Name it `TabPaw`.
4. Under **Connection**, choose **Tunnel**.
5. Select the tunnel created above, or paste the same `tunnel_id` when the UI
   permits it.
6. TabPaw uses a local stdio MCP server and needs no second MCP-server secret;
   keep authentication at the no-auth or default option shown by the UI.
7. Review the risk warning, acknowledge it, and create the private plugin.

Keep `tunnel-client` running during tool discovery. Chrome launches only when a
browser tool is first called.

## Troubleshooting

### The tunnel exists in Platform but is missing from ChatGPT

- Confirm that it is associated with the current ChatGPT workspace.
- Confirm that the operator has **Tunnels Read + Use**.
- Wait at least 30 seconds after creation, then refresh.

### Creating the tunnel returns 403

The selected organization or identity lacks **Tunnels Read + Manage**. Check
the active Platform organization, then ask an Owner or RBAC administrator to
adjust the role.

### `doctor` or `start` returns 403

The Runtime API key principal usually lacks **Tunnels Use**, or the key and the
tunnel belong to different organizations.

### ChatGPT sees the tunnel but discovers no tools

Confirm that `bash scripts/start.sh` is still running and inspect
`http://127.0.0.1:8080/ui`. If the local state is unhealthy, rerun
`bash scripts/doctor.sh` for the exact error.

