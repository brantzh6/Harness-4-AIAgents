---
name: sdlc-init
description: 在当前项目中一键初始化 AgentSDLC 开发规约体系（Qoder 版）。拷贝 SDLC 治理规约、模型路由策略、Project Profile、Claude Worker Agent 和代码到项目 .qoder/ 目录。当用户要求初始化 SDLC、设置开发规约、启用 AgentSDLC 治理框架时使用。
---

# SDLC 项目初始化（Qoder）

一键为当前项目初始化完整的 AgentSDLC 开发规约体系。

## 执行步骤

### 1. 创建目录结构

```powershell
New-Item -ItemType Directory -Path ".qoder/rules" -Force
New-Item -ItemType Directory -Path ".qoder/agents" -Force
New-Item -ItemType Directory -Path ".qoder/claude-worker" -Force
```

### 2. 拷贝规约文件

从全局 skill 目录拷贝所有规约：

```powershell
# SDLC 治理主合同
Copy-Item "$env:USERPROFILE\.qoder\rules\sdlc-governance.md" -Destination ".qoder/rules/"

# 模型路由策略模板
Copy-Item "$env:USERPROFILE\.qoder\skills\sdlc-init\templates\model-routing-policy.md" -Destination ".qoder/rules/"

# Project Profile 模板
Copy-Item "$env:USERPROFILE\.qoder\skills\sdlc-init\templates\project-profile.md" -Destination ".qoder/rules/"
```

### 3. 拷贝 Claude Worker Agent

```powershell
Copy-Item "$env:USERPROFILE\.qoder\skills\sdlc-init\templates\claude-worker.md" -Destination ".qoder/agents/"
```

### 4. 拷贝 Claude Worker 代码

```powershell
Copy-Item "$env:USERPROFILE\.qoder\skills\claude-worker\worker.py" -Destination ".qoder/claude-worker/"
```

### 5. 修改 Project Profile

初始化完成后，打开 `.qoder/rules/project-profile.md`，将以下字段改为当前项目的实际值：

- 项目名称和描述
- Project Level（L1/L2/L3）
- Project Type（A/B/C/D）
- 环境矩阵（dev/staging/production 路径）
- 验证命令（build/test/lint）
- 回滚策略
- Claude Worker 默认 provider

### 6. 输出确认

完成后向用户确认：

```
SDLC 规约初始化完成：
- .qoder/rules/sdlc-governance.md    — SDLC 治理主合同
- .qoder/rules/model-routing-policy.md — 模型路由策略
- .qoder/rules/project-profile.md     — Project Profile（请修改为项目实际值）
- .qoder/agents/claude-worker.md      — Claude Worker Agent
- .qoder/claude-worker/worker.py      — Claude Worker 代码

请检查 .qoder/rules/project-profile.md 并更新项目特定配置。
```
