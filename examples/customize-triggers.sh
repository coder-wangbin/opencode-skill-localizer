#!/bin/bash
# 示例：自定义技能触发条件
# 用法：bash examples/customize-triggers.sh

set -e

SKILL_FILE="$HOME/.config/opencode/superpowers/skills/test-driven-development/SKILL.md"

if [ ! -f "$SKILL_FILE" ]; then
    echo "❌ 未找到技能文件：$SKILL_FILE"
    exit 1
fi

echo "🔧 自定义 TDD 技能触发条件..."

sed -i '' 's/description: "Use when implementing any feature or bugfix, before writing implementation code"/description: "实现功能或修复 bug 前使用 — 先写测试、看着失败、写最小代码通过。触发：TDD、测试驱动、先测试后代码、red-green-refactor"/' "$SKILL_FILE"

git -C "$HOME/.config/opencode/superpowers" update-index --skip-worktree "$SKILL_FILE"

echo "✅ 触发条件已更新"
echo "📍 新触发词：TDD、测试驱动、先测试后代码、red-green-refactor"
