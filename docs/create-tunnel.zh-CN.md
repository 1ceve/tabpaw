# 创建 Secure MCP Tunnel

[English](create-tunnel.md)

Tunnel 是 OpenAI Platform 中的一条连接记录。ChatGPT 和 Mac 上运行的
`tunnel-client` 必须使用同一个 `tunnel_id`，才能找到彼此。

本教程使用 Platform 网页创建 tunnel。日常安装 TabPaw 不需要 Admin API key。

## 1. 确认功能与权限

开始前确认以下入口可以打开：

- [Platform Tunnels](https://platform.openai.com/settings/organization/tunnels)
- [ChatGPT Plugins](https://chatgpt.com/#settings/Connectors)

在 Platform 左上角的组织切换器中，选择真正要使用 TabPaw 的组织。创建或修改
tunnel 的身份需要 **Tunnels Read + Manage**；稍后运行 tunnel、在 ChatGPT 中
选择 tunnel 的身份需要 **Tunnels Read + Use**。

如果页面里没有 Tunnels、Create tunnel 或添加自定义 MCP server 的入口，通常是
当前账户尚未获得该功能，或工作区管理员还没有授予权限。

## 2. 在 Platform 创建 tunnel

1. 打开 [Platform Tunnels](https://platform.openai.com/settings/organization/tunnels)。
2. 点击 **Create tunnel**。按钮文字可能会随界面更新略有变化。
3. 名称可以填写 `TabPaw Browser`。
4. 描述可以填写 `Visible Chrome bridge for ChatGPT`，也可以留空。
5. 在组织或工作区范围中，选择稍后要使用 TabPaw 的 ChatGPT 工作区或个人空间。
   页面要求至少关联一个可用范围。
6. 确认并创建。

工作区关联很重要：tunnel 即使已经出现在 Platform 中，关联错工作区时也不会出现在
ChatGPT 的 tunnel 选择器里。

## 3. 保存 tunnel ID

创建完成后，打开 tunnel 详情并复制形如下面的 ID：

```text
tunnel_<32-character-id>
```

这是示例，不可直接使用。把自己的 tunnel ID 临时保存在本地，不要发进聊天、截图或
GitHub。新 tunnel 通常需要等待约 25–30 秒才会激活。

## 4. 写入 TabPaw 本地配置

先按照 README 复制示例配置：

```bash
mkdir -p "$HOME/.config/tunnel-client"
cp config/tabpaw.example.yaml "$HOME/.config/tunnel-client/tabpaw.yaml"
chmod 600 "$HOME/.config/tunnel-client/tabpaw.yaml"
```

打开这个本地文件：

```text
~/.config/tunnel-client/tabpaw.yaml
```

只把下面的占位符：

```yaml
tunnel_id: "tunnel_REPLACE_WITH_YOUR_ID"
```

换成自己的 tunnel ID。不要把 Runtime API key 写进 YAML；保留：

```yaml
api_key: "env:CONTROL_PLANE_API_KEY"
```

Runtime key 的创建方法见 [创建 Runtime API key](create-runtime-api-key.zh-CN.md)。

## 5. 检查并启动

在当前终端安全输入 Runtime API key：

```bash
read -s CONTROL_PLANE_API_KEY
export CONTROL_PLANE_API_KEY
echo
```

然后在 `tabpaw` 仓库目录中运行：

```bash
bash scripts/doctor.sh
bash scripts/start.sh
```

保持第二条命令继续运行。可以在浏览器打开下面的本地页面查看状态：

```text
http://127.0.0.1:8080/ui
```

显示 healthy、ready 并开始 polling 后，再去 ChatGPT 添加插件。

## 6. 在 ChatGPT 选择同一个 tunnel

这一步需要在 ChatGPT 网页端完成：

1. 打开 **Plugins**。
2. 点击加号，选择 **Add custom MCP server**。
3. 名称填写 `TabPaw`。
4. **Connection** 选择 **Tunnel**。
5. 从列表选择刚才创建的 tunnel；如果界面允许，也可以粘贴同一个 `tunnel_id`。
6. TabPaw 使用本地 stdio MCP server，不需要另一份 MCP server 密钥；认证项保持界面提供的
   无认证或默认选项。
7. 阅读风险提示，确认后创建私有插件。

工具发现期间，Mac 上的 `tunnel-client` 必须保持运行。第一次真正调用浏览器工具时，
Chrome 才会自动打开。

## 常见问题

### Platform 有 tunnel，ChatGPT 列表里没有

- 检查 tunnel 是否关联了当前 ChatGPT 工作区。
- 检查当前身份是否具有 **Tunnels Read + Use**。
- 创建后等待至少 30 秒，再刷新页面。

### 创建 tunnel 时出现 403

当前组织、身份或角色缺少 **Tunnels Read + Manage**。先确认 Platform 左上角选中的组织，
再请 Owner 或 RBAC 管理员调整权限。

### `doctor` 或 `start` 出现 403

Runtime key 所属身份通常缺少 **Tunnels Use**，也可能是 key 与 tunnel 来自不同组织。

### ChatGPT 能看到 tunnel，但发现不了工具

确认 `bash scripts/start.sh` 仍在运行，并查看 `http://127.0.0.1:8080/ui`。
如果本地状态不健康，重新运行 `bash scripts/doctor.sh` 查看具体错误。

