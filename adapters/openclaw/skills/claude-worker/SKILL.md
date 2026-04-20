---
name: claude-worker
description: Invoke Claude Worker (Claude Code CLI wrapper) for independent code review, coding, and testing tasks. Use when OpenClaw needs an independent second opinion for high-risk reviews, architecture arbitration, or Class C/D validation.
version: 1.0.0
author: brantzh6
tags:
  - claude-worker
  - review
  - coding
  - testing
metadata:
  activation: manual
  priority: normal
---

# Claude Worker Skill — OpenClaw

Invoke Claude Worker to perform independent coding, review, or testing tasks via Claude Code CLI.

## Prerequisites

- Claude Code CLI installed (`claude` command available)
- worker.py deployed (default: `~/.openclaw/skills/claude-worker/worker.py` or workspace `skills/`)

## When to Use

1. **High-risk independent review**: R3 / Class C / Class D tasks
2. **Architecture arbitration**: When your conclusion has uncertainty
3. **Low confidence**: When you're not sure about current approach
4. **Incident review**: Critical fix after major incident
5. **Gate requirements**: T3 G2 (design review) and G4 (code review)
6. **User request**: User explicitly asks for Claude Worker

## Task Mode (Single Task)

```bash
# Start task
python worker.py start --kind review --prompt "<task description>" --provider <provider>

# Wait for completion
python worker.py wait --run-id <run-id>

# Fetch results
python worker.py fetch --run-id <run-id>
```

## Session Chain Mode (Multi-round)

```bash
# Round 1
python worker.py start --kind coding --prompt "<initial task>" --provider <provider>
python worker.py wait --run-id <run-id>
python worker.py fetch --run-id <run-id>

# Round 2+
python worker.py continue --run-id <run-id> --prompt "<follow-up>"
python worker.py wait --run-id <run-id>
python worker.py fetch --run-id <run-id>
```

## Result Parsing

1. Check `exitcode.txt` → 0 = success
2. Read `final.json` → structured result
3. If abnormal → read `stdout.txt`
4. Format as structured report

## Default Configuration

```yaml
worker_path: worker.py
default_provider: qwen-bailian-coding
default_model: qwen3.6-plus
fallback_provider: z-ai
fallback_model: glm-5
default_effort: high
```

## Providers

| Provider | Models | Best For |
|----------|--------|----------|
| z-ai | glm-5.1, glm-5 | Backend, high-risk final review |
| qwen-bailian-coding | qwen3.6-plus | Daily architecture, frontend |
| openrouter | claude-opus, claude-sonnet | External independent perspective |
| kimi | kimi-k2.5 | Review |

## Rules

- Do NOT use Claude Worker as default reviewer (high-value scenarios only)
- Do NOT retry more than 2 times on failure — escalate to user
- Do NOT make final architecture decisions (return results to OpenClaw for decision)
- Do NOT bypass project routing policy
