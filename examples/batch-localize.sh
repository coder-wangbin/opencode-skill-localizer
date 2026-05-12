#!/bin/bash
# 示例：批量本地化多个技能目录
# 用法：bash examples/batch-localize.sh

set -e

SKILL_DIRS=(
    "$HOME/.config/opencode/superpowers"
    "$HOME/.config/opencode/anthropic-skills"
)

for dir in "${SKILL_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "📂 处理：$dir"
        cd "$dir"
        git update-index --skip-worktree skills/*/SKILL.md 2>/dev/null || echo "  ⚠️  无 skills 目录，跳过"
        echo "  ✅ 已保护本地修改"
    else
        echo "  ⚠️  目录不存在：$dir"
    fi
done

echo ""
echo "🎉 批量本地化完成！"
