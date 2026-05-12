#!/bin/bash
# OpenCode Skill Localizer - 自动安装脚本
# 用法：curl -fsSL https://raw.githubusercontent.com/coder-wangbin/opencode-skill-localizer/main/scripts/install.sh | bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 OpenCode Skill Localizer 安装脚本${NC}"
echo ""

# 检查 OpenCode 配置目录是否存在
OPENCODE_DIR="$HOME/.config/opencode"
SKILLS_DIR="$OPENCODE_DIR/skills"

if [ ! -d "$OPENCODE_DIR" ]; then
    echo -e "${RED}❌ 未找到 OpenCode 配置目录：$OPENCODE_DIR${NC}"
    echo -e "${YELLOW}请先安装 OpenCode 并确保至少运行过一次${NC}"
    exit 1
fi

# 创建 skills 目录（如果不存在）
mkdir -p "$SKILLS_DIR"

# 安装技能文件
SKILL_NAME="localize-skill-descriptions"
SKILL_DEST="$SKILLS_DIR/$SKILL_NAME"

echo -e "📦 正在安装技能：${GREEN}$SKILL_NAME${NC}"

# 从 GitHub 克隆或更新
if [ -d "$SKILL_DEST" ]; then
    echo -e "${YELLOW}⚠️  技能已存在，正在更新...${NC}"
    cd "$SKILL_DEST"
    git pull 2>/dev/null || echo -e "${YELLOW}非 git 管理的技能，跳过更新${NC}"
else
    # 直接从仓库复制（如果已克隆）
    REPO_DIR="$HOME/Projects/opencode-skill-localizer"
    if [ -d "$REPO_DIR" ]; then
        cp -r "$REPO_DIR/skill" "$SKILL_DEST"
        echo -e "${GREEN}✅ 技能已从本地仓库复制${NC}"
    else
        echo -e "${YELLOW}⚠️  未找到本地仓库，请手动克隆：${NC}"
        echo "   git clone https://github.com/YOUR_USERNAME/opencode-skill-localizer.git"
        echo "   cp -r opencode-skill-localizer/skill $SKILL_DEST"
        exit 1
    fi
fi

# 验证安装
if [ -f "$SKILL_DEST/SKILL.md" ]; then
    echo -e "${GREEN}✅ 技能安装成功！${NC}"
    echo ""
    echo -e "📍 安装位置：${GREEN}$SKILL_DEST/SKILL.md${NC}"
    echo ""
    echo -e "${YELLOW}下一步：${NC}"
    echo "  1. 重启 OpenCode"
    echo "  2. 使用 /localize-skill-descriptions 查看技能"
    echo ""
else
    echo -e "${RED}❌ 安装失败：未找到 SKILL.md${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 安装完成！${NC}"
