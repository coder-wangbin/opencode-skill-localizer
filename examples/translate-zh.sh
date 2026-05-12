#!/bin/bash
# 示例：将 Superpowers 技能描述翻译为中文
# 用法：bash examples/translate-zh.sh

set -e

SUPERPOWERS_DIR="$HOME/.config/opencode/superpowers"

if [ ! -d "$SUPERPOWERS_DIR" ]; then
    echo "❌ 未找到 Superpowers 目录：$SUPERPOWERS_DIR"
    exit 1
fi

cd "$SUPERPOWERS_DIR"

echo "🔄 开始翻译 Superpowers 技能描述..."

declare -A TRANSLATIONS=(
    ["brainstorming"]="创造性工作前必用 — 探索用户意图、需求和设计，确认后再实现"
    ["systematic-debugging"]="遇到错误、测试失败或意外行为时使用 — 必须先找根本原因，随机修复是浪费"
    ["test-driven-development"]="实现功能或修复 bug 前使用 — 先写测试、看着失败、写最小代码通过"
    ["using-superpowers"]="开始任何对话时使用 — 建立技能使用规范，任何响应前先调用技能检查"
    ["dispatching-parallel-agents"]="2+ 个独立任务可并行执行时使用 — 分配给子智能体同时处理"
    ["executing-plans"]="有现成实施计划需在单独会话中执行时使用 — 加载计划、审查、执行、报告"
    ["finishing-a-development-branch"]="实现完成、测试通过后整合工作时使用 — 验证测试、呈现选项、执行合并或 PR"
    ["receiving-code-review"]="收到代码审查反馈时使用 — 要求技术验证，不盲目认同或直接实施"
    ["requesting-code-review"]="完成任务或合并前验证工作时使用 — 在问题级联前发现并修复问题"
    ["subagent-driven-development"]="当前会话中执行独立任务计划时使用 — 子智能体执行计划，每任务后两阶段审查"
    ["using-git-worktrees"]="开始需要隔离的功能工作或执行计划前使用 — 确保存在独立工作区"
    ["verification-before-completion"]="声称工作完成或测试通过前使用 — 必须运行验证命令确认；证据先于断言"
    ["writing-plans"]="有多步任务规格时、接触代码前使用 — 编写全面实施计划"
    ["writing-skills"]="创建技能、编辑技能或部署前验证时使用 — 技能编写是测试驱动开发在文档中的应用"
)

for skill_name in "${!TRANSLATIONS[@]}"; do
    skill_file="skills/$skill_name/SKILL.md"
    if [ -f "$skill_file" ]; then
        new_desc="${TRANSLATIONS[$skill_name]}"
        sed -i '' "s/description: .*/description: \"$new_desc\"/" "$skill_file"
        echo "✅ $skill_name → $new_desc"
    fi
done

echo ""
echo "🔒 保护本地修改..."
git update-index --skip-worktree skills/*/SKILL.md

echo ""
echo "🔗 创建符号链接..."
ln -sf "$SUPERPOWERS_DIR/skills" "$HOME/.config/opencode/skills/superpowers"

echo ""
echo "🎉 翻译完成！重启 OpenCode 后生效"
