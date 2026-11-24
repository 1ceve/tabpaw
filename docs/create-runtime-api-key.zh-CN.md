# 创建 Runtime API key

[English](create-runtime-api-key.md)

TabPaw 需要一个 OpenAI Platform **Runtime API key**，供本地
`tunnel-client` 连接 tunnel。创建 Restricted key，只开放运行时真正需要的
两个 tunnel 权限即可。

## 创建前先确认组织

在 OpenAI Platform 中，切换到拥有该 tunnel、并且已经关联目标 ChatGPT
个人账户或工作区的组织。API key 与 tunnel 权限都属于当前选中的组织；选错组织时，
即使 key 本身有效也可能收到 403。

## 创建 key

1. 打开 [Platform Runtime API keys](https://platform.openai.com/settings/organization/api-keys)。
2. 新建 secret key，取一个容易辨认的名字，例如 `tabpaw-runtime`。
3. 权限选择 **Restricted**。
4. 找到 **Tunnels** 一行，只启用：
   - **Read**
   - **Use**
5. 除非这个身份还要创建或修改 tunnel，否则不要启用 **Manage**。
6. 创建后把 key 保存在私密的位置。不要发进 ChatGPT 对话，不要放进 GitHub、
   TabPaw 的 YAML 配置或截图。

如果页面上没有创建按钮或权限选项，需要请组织 Owner 或 RBAC 管理员授予对应角色，
或代为创建 key。

## 放进当前终端

在稍后要运行 TabPaw 的终端里输入：

```bash
read -s CONTROL_PLANE_API_KEY
export CONTROL_PLANE_API_KEY
echo
```

粘贴 key 后按回车。输入过程中屏幕没有任何字符是正常现象。

可以这样确认变量已经存在，同时不会把秘密打印出来：

```bash
test -n "${CONTROL_PLANE_API_KEY:-}" && echo "key 已设置" || echo "key 未设置"
```

这个变量只在当前 shell 会话里有效。关闭终端后，下次启动 TabPaw 前需要重新输入。

## Runtime key 和 Admin key 的区别

| Key | 用途 | TabPaw 日常运行需要吗 |
| --- | --- | --- |
| Runtime API key | `tunnel-client doctor` 与 `tunnel-client run` | 需要：**Tunnels Read + Use** |
| Admin API key | 通过管理 API 创建、修改或删除 tunnel | 不需要 |

不要把 Admin API key 交给长期运行的 TabPaw 进程。如果 key 意外泄露，立即在
Platform 中撤销它，创建替代 key 后再继续使用。

