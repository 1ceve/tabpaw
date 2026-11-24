# 排错手册

[English](troubleshooting.md)

遇到问题时先运行：

```bash
bash scripts/doctor.sh
```

使用示例配置时，也可以打开本地运行状态页面：

```text
http://127.0.0.1:8080/ui
```

| 现象 | 可能原因 | 处理方法 |
| --- | --- | --- |
| `CONTROL_PLANE_API_KEY` 引用无效 | 当前 shell 中没有这个环境变量 | 在同一个终端输入并导出 Runtime API key，再重新运行 `doctor` |
| ChatGPT 找不到插件 | tunnel 已停止、Mac 睡眠、网络中断，或 tunnel 没有关联当前 ChatGPT 空间 | 唤醒 Mac，确认网络与本地状态正常，检查 tunnel 关联后重启 |
| Chrome 已经出现，但工具调用超时 | tunnel 或 MCP 子进程已经断开 | 停止 tunnel，完全退出专用 Chrome，再重新启动 |
| Chrome 提示档案正在使用 | 另一个 Chrome 进程占用了同一个用户数据目录 | 完全退出所有使用该专用档案的 Chrome，再重新启动 |
| 网站意外退出登录 | 打开了不同的 Chrome 档案，或 Cookie 已过期 | 确认使用文档中的默认档案，再亲自登录一次 |
| 网站提示流量异常或出现验证码 | 网站识别到了自动化浏览器 | 停止 tunnel，运行 `manual-login-macos.sh`；不要让自动化反复尝试账号密码 |
| Google 提示登录环境不安全 | Google 识别到了自动化 Chrome | 在同一个专用档案中手动完成登录，完全退出 Chrome，再启动 TabPaw |
| 端口 `8080` 已被占用 | 另一个进程正在使用健康检查监听端口 | 停止那个进程，或复制配置并修改 `listen_addr` |
| 找不到 `npx` | tunnel 进程无法使用 Node.js/npm | 安装 Node.js LTS，并确认该进程的 `PATH` 中包含 `npx` |

## 完整重启顺序

1. 在运行 TabPaw 的终端按 `Ctrl+C`。
2. 完全退出专用 Chrome。
3. 打开一个新终端。
4. 如果配置通过环境变量读取 key，重新设置 `CONTROL_PLANE_API_KEY`。
5. 运行 `bash scripts/doctor.sh`。
6. 运行 `bash scripts/start.sh`。
7. 先用一个无副作用的只读网页任务测试。

## 不暴露秘密的检查方法

下面这些命令可以安全地确认基本状态：

```bash
test -n "${CONTROL_PLANE_API_KEY:-}" \
  && echo "CONTROL_PLANE_API_KEY is set" \
  || echo "CONTROL_PLANE_API_KEY is NOT set"

tunnel-client --version
node --version
npm --version
```

不要把原始 API key、Cookie、本地浏览器数据库或完整诊断压缩包发到公开 issue。
分享日志前，需要遮住 tunnel ID 与个人路径。

## 浏览器档案位置

Chrome DevTools MCP 在 macOS 稳定版 Chrome 上使用的默认档案位置是：

```text
~/.cache/chrome-devtools-mcp/chrome-profile
```

这个档案会在多次运行之间继续使用，同一时间只能由一个浏览器进程占用。
如果加入 `--isolated`，Chrome DevTools MCP 会创建临时档案，TabPaw 需要的登录状态持久化也会失效。

## 仍然没有解决？

提交 issue 前，可以先查看上游项目的官方文档：

- [Secure MCP Tunnel 指南](https://developers.openai.com/api/docs/guides/secure-mcp-tunnels)
- [`openai/tunnel-client` 排错说明](https://github.com/openai/tunnel-client/blob/master/docs/troubleshooting.md)
- [Chrome DevTools MCP 排错说明](https://github.com/ChromeDevTools/chrome-devtools-mcp/blob/main/docs/troubleshooting.md)

报告 TabPaw 文档问题时，请提供脱敏后的版本信息、出错步骤、完整但不含秘密的错误文本，
以及原本期待出现的结果。
