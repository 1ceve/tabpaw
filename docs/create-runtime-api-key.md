# Create the Runtime API key

[简体中文](create-runtime-api-key.zh-CN.md)

TabPaw needs an OpenAI Platform **Runtime API key** to keep the local
`tunnel-client` connected. Use a restricted key with only the two tunnel
permissions required by the runtime.

## Before you start

In OpenAI Platform, switch to the organization that owns the tunnel and is
associated with the ChatGPT account or workspace where TabPaw will be used.
API keys and tunnel permissions belong to the selected organization.

## Create the key

1. Open [Platform Runtime API keys](https://platform.openai.com/settings/organization/api-keys).
2. Create a new secret key and give it a recognizable name, such as
   `tabpaw-runtime`.
3. Choose **Restricted** permissions.
4. In the **Tunnels** permission row, enable:
   - **Read**
   - **Use**
5. Leave **Manage** disabled unless this same identity also needs to create or
   edit tunnels.
6. Create the key and keep it somewhere private. Do not paste it into a ChatGPT
   conversation, GitHub, the TabPaw YAML file, or a screenshot.

If the key controls are unavailable, ask an organization Owner or RBAC
administrator to grant the required role or create the key for you.

## Load it into the current terminal

From the terminal that will run TabPaw:

```bash
read -s CONTROL_PLANE_API_KEY
export CONTROL_PLANE_API_KEY
echo
```

Paste the key and press Return. The terminal intentionally shows no characters
while the key is entered.

Check that the variable exists without printing the secret:

```bash
test -n "${CONTROL_PLANE_API_KEY:-}" && echo "key is set" || echo "key is missing"
```

The variable lasts only for this shell session. If you close the terminal, enter
it again before starting TabPaw.

## Runtime key or Admin key?

| Key | Used for | TabPaw normally needs it? |
| --- | --- | --- |
| Runtime API key | `tunnel-client doctor` and `tunnel-client run` | Yes: **Tunnels Read + Use** |
| Admin API key | Creating, editing, or deleting tunnels through administrative APIs | No |

Never put an Admin API key in the long-running TabPaw process. If a key is
accidentally exposed, revoke it in Platform and create a replacement before
continuing.

