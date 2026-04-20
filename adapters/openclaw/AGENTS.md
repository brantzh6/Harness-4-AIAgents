# Harness-4-AIAgents — OpenClaw Project Context

> This file is injected into OpenClaw at project load time via AGENTS.md convention.
> It defines the governance framework and operational constraints for this project.

## Governance Framework

This project operates under **AgentSDLC v3.1** governance. You have two skills available:

1. **sdlc-harness**: SDLC lifecycle rules, task classification, Gate system, review discipline
2. **claude-worker**: Claude Worker CLI for independent external review

## Mandatory Workflow

Before starting any non-trivial task:
1. Run task classification (Level/Type/Risk/Class → Template → Gate Profile)
2. Follow the 7-stage lifecycle (Design → Design Review → Impl → Code Review → Test → Deploy → Monitor)
3. Apply the correct Gate strictness based on your Gate Profile (G-Lite/G-Std/G-Full)

## When to Use Claude Worker

- **Must use**: R3 code review, Class C/D review, architecture disputes, low confidence
- **Optional**: T2 review with unexpected complexity, need contrarian perspective
- **Do not use**: T1 tasks, trivial T2, pure documentation, routine bulk coding

## Model Routing

| Scenario | Executor | Reviewer |
|----------|----------|----------|
| Daily development | OpenClaw | OpenClaw (role-switch) |
| High-risk coding | OpenClaw | Claude Worker |
| Architecture dispute | OpenClaw drafts | Claude Worker arbitrates |
| T3 / Class C/D | OpenClaw implements | Claude Worker reviews (mandatory) |

## Setup

To initialize Claude Worker for this project:

```bash
# Copy worker.py to project
cp ~/.openclaw/skills/claude-worker/worker.py ./worker.py

# Or download directly
curl -o worker.py https://raw.githubusercontent.com/brantzh6/claude-worker/main/code/services/api/claude_worker/worker.py
```

## Project Defaults

```yaml
project_level: L2
project_type: B
default_risk: R2
default_class: B
default_template: T2
default_gate_profile: G-Std
```

Update the values above to match your actual project characteristics.
