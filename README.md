# Harness-4-AIAgents

SDLC governance harness for AI agents — powered by [AgentSDLC](https://github.com/brantzh6/AgentSDLC) + [Claude Worker](https://github.com/brantzh6/claude-worker).

## What is this?

A skills project that constrains AI coding agents to work under structured SDLC governance. It provides:

- **Task classification** (Level/Type/Risk/Class) before coding starts
- **7-stage lifecycle** with Gates (Design → Review → Impl → Code Review → Test → Deploy → Monitor)
- **Claude Worker integration** for independent external review on high-risk tasks
- **Model routing policy** — when to self-review vs. when to call Claude Worker

## Supported Agents

| Agent | Type | Skill Format | Context Injection |
|-------|------|-------------|-------------------|
| [Qoder](https://qoder.ai) | IDE-integrated | `.qoder/rules/` + `.qoder/agents/` | Auto-loaded from project `.qoder/` |
| [Hermes](https://github.com/NousResearch/hermes-agent) | Python CLI | `~/.hermes/skills/<name>/SKILL.md` | `AGENTS.md` in project root |
| [OpenClaw](https://github.com/openclaw/openclaw) | Node.js agent | `~/.openclaw/skills/<name>/SKILL.md` | `AGENTS.md` + `SOUL.md` in project root |

## Project Structure

```
Harness-4-AIAgents/
├── core/                              # Agent-agnostic governance rules
│   ├── sdlc-governance.md             # Full SDLC v3.1 governance contract
│   ├── claude-worker-skill.md         # Claude Worker usage reference
│   └── model-routing-policy.md        # Model routing template
├── adapters/
│   ├── qoder/                         # Qoder IDE adapter
│   │   ├── rules/sdlc-governance.md   # Qoder-specific SDLC rules
│   │   ├── agents/claude-worker.md    # Claude Worker agent definition
│   │   └── skills/sdlc-init/SKILL.md  # One-click project init skill
│   ├── hermes/                        # Hermes agent adapter
│   │   ├── skills/sdlc-harness/       # SDLC governance skill
│   │   ├── skills/claude-worker/      # Claude Worker skill
│   │   ├── AGENTS.md                  # Project context template
│   │   └── init.sh                    # One-click init script
│   └── openclaw/                      # OpenClaw agent adapter
│       ├── skills/sdlc-harness/       # SDLC governance skill
│       ├── skills/claude-worker/      # Claude Worker skill
│       ├── AGENTS.md                  # Project context template
│       └── init.sh                    # One-click init script
└── samples/
    └── project-profile.md             # Project profile template
```

## Quick Start

### Qoder

In any project, tell Qoder:

> 初始化 SDLC 规约

Or manually copy from `adapters/qoder/` to your project's `.qoder/` directory.

### Hermes

```bash
# One-click setup
bash <(curl -sL https://raw.githubusercontent.com/brantzh6/Harness-4-AIAgents/main/adapters/hermes/init.sh)

# Or manually
cp adapters/hermes/skills/sdlc-harness/SKILL.md ~/.hermes/skills/sdlc-harness/SKILL.md
cp adapters/hermes/skills/claude-worker/SKILL.md ~/.hermes/skills/claude-worker/SKILL.md
cp adapters/hermes/AGENTS.md ./AGENTS.md
```

### OpenClaw

```bash
# One-click setup
bash <(curl -sL https://raw.githubusercontent.com/brantzh6/Harness-4-AIAgents/main/adapters/openclaw/init.sh)

# Or manually
cp adapters/openclaw/skills/sdlc-harness/SKILL.md ~/.openclaw/skills/sdlc-harness/SKILL.md
cp adapters/openclaw/skills/claude-worker/SKILL.md ~/.openclaw/skills/claude-worker/SKILL.md
cp adapters/openclaw/AGENTS.md ./AGENTS.md
```

## How It Works

### 1. Task Classification

Before any non-trivial task, the agent classifies it:

```
Level: L2 (persistent personal project)
Type: B (App/API)
Risk: R2 (medium)
Class: B (runtime behavior change)
→ Template: T2, Gate Profile: G-Std
```

### 2. Lifecycle Enforcement

The agent follows the 7-stage lifecycle with Gates:

```
Design (G1) → Design Review (G2) → Implementation (G3) → Code Review (G4) → Testing (G5) → Deploy (G6) → Monitor (G7)
```

### 3. Claude Worker for Independent Review

For high-risk tasks (R3, Class C/D, T3), the agent calls Claude Worker:

```bash
python worker.py start --kind review --prompt "Review changes for ..." --provider qwen-bailian-coding
python worker.py wait --run-id <id>
python worker.py fetch --run-id <id>
```

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed (`claude` command available)
- [worker.py](https://github.com/brantzh6/claude-worker) — download from Claude Worker repo
- At least one configured provider (see `core/claude-worker-skill.md` for provider list)

## License

MIT
