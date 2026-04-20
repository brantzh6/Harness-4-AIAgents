#!/bin/bash
# Harness-4-AIAgents — Hermes 项目初始化脚本
# 用法: bash init.sh [project-dir]

set -e

PROJECT_DIR="${1:-.}"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
HARNESS_REPO="https://raw.githubusercontent.com/brantzh6/Harness-4-AIAgents/main"

echo "=== Harness-4-AIAgents: Hermes 初始化 ==="
echo "项目目录: $PROJECT_DIR"

# 1. 创建 skill 目录
echo "[1/4] 创建 skill 目录..."
mkdir -p "$HERMES_HOME/skills/sdlc-harness"
mkdir -p "$HERMES_HOME/skills/claude-worker"

# 2. 下载 skills
echo "[2/4] 安装 sdlc-harness skill..."
curl -sL "$HARNESS_REPO/adapters/hermes/skills/sdlc-harness/SKILL.md" \
  -o "$HERMES_HOME/skills/sdlc-harness/SKILL.md"

echo "[3/4] 安装 claude-worker skill..."
curl -sL "$HARNESS_REPO/adapters/hermes/skills/claude-worker/SKILL.md" \
  -o "$HERMES_HOME/skills/claude-worker/SKILL.md"

# 下载 worker.py
curl -sL "https://raw.githubusercontent.com/brantzh6/claude-worker/main/code/services/api/claude_worker/worker.py" \
  -o "$HERMES_HOME/skills/claude-worker/worker.py"

# 3. 拷贝 AGENTS.md 到项目
echo "[4/4] 部署 AGENTS.md..."
curl -sL "$HARNESS_REPO/adapters/hermes/AGENTS.md" \
  -o "$PROJECT_DIR/AGENTS.md"

echo ""
echo "=== 初始化完成 ==="
echo "已安装:"
echo "  $HERMES_HOME/skills/sdlc-harness/SKILL.md"
echo "  $HERMES_HOME/skills/claude-worker/SKILL.md"
echo "  $HERMES_HOME/skills/claude-worker/worker.py"
echo "  $PROJECT_DIR/AGENTS.md"
echo ""
echo "请编辑 $PROJECT_DIR/AGENTS.md 中的 Project Defaults 以匹配项目实际情况。"
