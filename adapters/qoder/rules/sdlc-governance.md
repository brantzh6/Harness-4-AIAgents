# AgentSDLC 治理规约 — Qoder 适配版

> 基于 AgentSDLC v3.1，适配 Qoder IDE 作为 controller + implementer 双角色的工作模式。
> 部署位置：`.qoder/rules/sdlc-governance.md`

---

## 1. 角色定义

在 Qoder 环境中：
- **Qoder = controller + 主实施者**（直接编码、测试、review）
- **Claude Worker = 可选外部独立 reviewer**（通过 CLI 调用 Claude Code）
- Qoder 在 T1/T2 日常任务中兼任 controller 和 implementer
- 在 T2+ 高风险和 T3 任务中，Qoder 必须通过 role-switching 或调用 Claude Worker 实现独立审查

**完整规约详见 core/sdlc-governance.md。以下为 Qoder 特定适配。**

---

## 2. Qoder 特定适配

### 2.1 规则加载机制
- Qoder 只自动加载项目级 `.qoder/rules/` 目录下的文件
- 全局 `~/.qoder/rules/` **不会**自动注入
- 因此所有规则必须部署到项目级目录

### 2.2 Claude Worker 集成
- Agent 定义：`.qoder/agents/claude-worker.md`
- Worker 代码：`.qoder/claude-worker/worker.py`
- 通过 Qoder 的 Agent 机制调用，支持 Terminal、Read、Grep、Glob 工具

### 2.3 Role-Switching 实现
Qoder 作为单 agent，通过以下方式实现 role-switching：
- 在 review 阶段，Qoder 显式切换到"reviewer 视角"
- 使用不同的评估标准（见 core/sdlc-governance.md §6）
- 产出结构化 review 结果（pass / conditional pass / reject）

### 2.4 Skill 集成
- `sdlc-init` skill：一键初始化项目 SDLC 规约
- `claude-worker` skill：全局 Claude Worker 调用知识

---

## 3. 部署清单

```
.qoder/
├── rules/
│   ├── sdlc-governance.md        ← 本文件
│   ├── model-routing-policy.md   ← 模型路由策略
│   ├── model-registry.md         ← 模型注册表
│   ├── monitoring-feedback-loop.md ← 监控反馈闭环
│   ├── testing-standards.md      ← 测试规约
│   └── project-profile.md        ← 项目 Profile
├── agents/
│   └── claude-worker.md          ← Claude Worker Agent
├── claude-worker/
│   └── worker.py                 ← Claude Worker 代码
└── logs/sdlc/                    ← SDLC 日志目录
```
