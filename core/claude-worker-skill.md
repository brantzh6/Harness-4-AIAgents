# Claude Worker Skill — 通用版

> 教 AI Agent 如何调用 Claude Worker 完成独立编码、review 和测试任务。
> Claude Worker 是 Claude Code CLI 的结构化包装层，提供 Task Mode、Session Chain Mode 和 Live Session Mode 三种调用模式。

---

## 1. 前置条件

- Claude Code CLI 已安装（`claude` 命令可用）
- worker.py 已部署到 agent 可访问的路径
- 项目使用时从全局拷贝到项目本地

---

## 2. 三种调用模式

### 2.1 Task Mode（单次任务）

适用：单次独立任务，如一次 review、一次编码、一次测试。

```bash
# 启动任务
python worker.py start --kind coding --prompt "<任务描述>" --provider <provider>

# 等待完成
python worker.py wait --run-id <run-id>

# 获取结果
python worker.py fetch --run-id <run-id>
```

**Detached 模式**（适合长时间任务）：
```bash
python worker.py start --kind coding --prompt "<任务描述>" --execution-mode detached --provider <provider>
# 稍后获取
python worker.py fetch --run-id <run-id>
```

**使用场景**：
- Controller 驱动的 fire-and-forget 委派
- CI/CD 管道、批量任务
- 任何需要干净请求/响应边界的场景

### 2.2 Session Chain Mode（多轮迭代）

适用：需要多轮迭代的任务，如 code → review → fix → test。

```bash
# 第一轮
python worker.py start --kind coding --prompt "<初始任务>" --provider <provider>
python worker.py wait --run-id <run-id>
python worker.py fetch --run-id <run-id>

# 后续轮次（上下文通过 --resume 保持）
python worker.py continue --run-id <run-id> --prompt "<后续指令>"
python worker.py wait --run-id <run-id>
python worker.py fetch --run-id <run-id>
```

**关键特性**：
- 每个 continue 是一个全新子进程，通过 CC 的 --resume 保持上下文
- 崩溃可恢复：caller 崩溃后可通过 run-id 继续
- 可在每轮之间检查结果并决定下一步

**使用场景**：
- 迭代编码工作流（编码 → review → 修复 → 测试）
- 轮间需要人为决策
- caller 进程可能在轮间重启

### 2.3 Live Session Mode（实时交互）

适用：长时间探索性会话，需要实时注入指令。

```bash
# 启动会话
python worker.py session-start --prompt "<初始任务>" --provider <provider>

# 发送后续指令
python worker.py session-send --session-id <id> --prompt "<后续指令>"

# 捕获当前输出
python worker.py session-capture --session-id <id>

# 结束会话
python worker.py session-stop --session-id <id>
```

**使用场景**：
- Agent-to-agent 协作
- 实时监控 + 控制
- 上下文不能丢失且重启延迟不可接受的场景

---

## 3. Provider 管理

### 3.1 可用 Provider

| Provider | 模型 | 推荐用途 |
|----------|------|----------|
| z-ai | glm-5.1, glm-5, glm-4.7 | 后端、高风险终审 |
| qwen-bailian-coding | qwen3.6-plus, qwen3-coder-plus, glm-5 | 日常架构、前端 |
| qwen-bailian | qwen3.6-plus, qwen3-max | 长上下文、大材料 |
| deepseek | deepseek-chat, deepseek-reasoner | 可选 |
| openrouter | claude-opus, claude-sonnet, gpt-4o | 外部独立视角 |
| kimi | kimi-k2.5 | review |
| minimax | MiniMax-M2.5 | 高速铺量 |
| anthropic | claude models | 原生 Claude |

### 3.2 Provider 操作

```bash
# 查看所有 provider 状态
python worker.py provider list

# 设置 API key
python worker.py provider set-key <provider-name>

# 验证连通性
python worker.py provider verify <provider-name>

# 添加自定义 provider
python worker.py provider add <name> --base-url <url> --api-key-env <env-var> --models <model1> <model2>
```

### 3.3 Credential 解析顺序

1. CredentialStore (~/.claude-worker/credentials.db)
2. 环境变量
3. cc-switch DB（旧兼容）
4. ~/.claude/settings.json（最后手段）

---

## 4. 输出产物

每次运行产出以下文件：

| 文件 | 内容 |
|------|------|
| `final.json` | 结构化最终结果 |
| `stdout.txt` | 完整标准输出 |
| `stderr.txt` | 标准错误输出 |
| `exitcode.txt` | 退出码 |
| `events.ndjson` | 事件流日志（NDJSON 格式） |
| `prompt.txt` | 原始 prompt |
| `supervisor.json` | 运行元数据 |

### 结果解析流程

```
1. 检查 exitcode.txt → 0 表示成功
2. 读取 final.json → 获取结构化结果
3. 如果 final.json 不存在或异常 → 读取 stdout.txt 获取原始输出
4. 检查 events.ndjson → 获取工具调用记录和中间步骤
```

---

## 5. 安全边界

### 5.1 关键参数

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--max-turns` | 最大轮次限制 | 无限制 |
| `--allowed-tools` | 允许的工具白名单 | 全部 |
| `--permission-mode` | 权限模式 | bypassPermissions |
| `--model` | 指定模型 | qwen3.6-plus |
| `--effort` | 推理深度 | high |

### 5.2 安全建议

- Review 任务建议限制 `--allowed-tools` 为只读工具
- 高风险任务建议设置 `--max-turns` 上限
- 生产环境相关任务不使用 `bypassPermissions`

---

## 6. 与 SDLC Gate 的对接

| Gate | 调用时机 | 推荐模式 | 场景 |
|------|----------|----------|------|
| G2 设计审查 | T3 / Class C/D | Task Mode | 独立设计 review |
| G4 代码审查 | T2+ 高风险 | Task Mode | 独立代码 review |
| G3 实施 | 高风险编码 | Session Chain | 迭代编码 → review → 修复 |
| G5 测试 | T3 | Task Mode | 独立测试设计和执行 |
| 仲裁 | 结论冲突 | Task Mode | 第二意见 |

---

## 7. 错误处理

### 常见错误及处理

| 错误 | 原因 | 处理 |
|------|------|------|
| exitcode != 0 | CC 执行失败 | 检查 stderr.txt，可能是 provider 连通性问题 |
| provider verify 失败 | API key 或网络问题 | 检查 credential 配置，重新 set-key |
| timeout | 任务超时 | 增加 --wait-timeout 或使用 detached 模式 |
| final.json 缺失 | CC 异常退出 | 回退到 stdout.txt 解析 |

### 重试策略

1. 第一次失败：检查 exitcode 和 stderr，诊断原因
2. provider 问题：切换到备用 provider 重试
3. 内容问题：调整 prompt 后重试
4. 持续失败：上报用户，不自行循环重试超过 2 次
