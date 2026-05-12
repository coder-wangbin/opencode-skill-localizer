# OpenCode Skill Localizer

> 🌍 本地化 AI 助手技能描述，使用 `git skip-worktree` 保护本地修改不被覆盖。

## 问题场景

当你想自定义通过 git 安装的 OpenCode/Claude Code 技能时（比如翻译技能描述为中文），会遇到冲突：

- 🔄 `git pull` 更新会覆盖你的本地修改
- 📁 创建重复文件意味着维护两份副本
- ⚠️ 使用 `--assume-unchanged` 很危险 — git 仍可能覆盖这些文件

## 解决方案

使用 `git update-index --skip-worktree` 保护本地修改，同时通过符号链接保持技能发现机制正常工作。

### 核心优势

| 特性 | 说明 |
|------|------|
| ✅ 安全 | `skip-worktree` 专为本地覆盖设计，不会被 `git pull` 覆盖 |
| ✅ 简洁 | 无需维护重复文件，单一数据源 |
| ✅ 可回滚 | 随时恢复跟踪上游更新 |
| ✅ 通用 | 适用于任何 git 管理的技能目录 |

## 快速开始

### 方法一：自动安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/opencode-skill-localizer/main/scripts/install.sh | bash
```

### 方法二：手动安装

```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/opencode-skill-localizer.git
cd opencode-skill-localizer

# 2. 将技能文件复制到你的 OpenCode 配置目录
cp -r skill/ ~/.config/opencode/skills/localize-skill-descriptions/

# 3. 重启 OpenCode，使用 /localize-skill-descriptions 查看技能
```

## 使用示例

### 场景 1：翻译 Superpowers 技能描述为中文

```bash
# 进入 Superpowers 技能目录
cd ~/.config/opencode/superpowers

# 批量替换 description 字段
for skill in skills/*/SKILL.md; do
  sed -i '' 's/Use when starting any conversation/开始任何对话时使用/' "$skill"
  sed -i '' 's/Use when encountering any bug/遇到错误、测试失败或意外行为时使用/' "$skill"
  # ... 其他翻译
done

# 保护本地修改
git update-index --skip-worktree skills/*/SKILL.md

# 创建符号链接（如果技能发现机制扫描不同目录）
ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers
```

### 场景 2：自定义技能触发条件

```bash
# 编辑特定技能的 SKILL.md
vim ~/.config/opencode/superpowers/skills/test-driven-development/SKILL.md

# 修改 description 添加自定义触发词
# description: "实现功能或修复 bug 前使用 — 先写测试、看着失败、写最小代码通过。触发：TDD、测试驱动、先测试后代码"

# 保护修改
git update-index --skip-worktree skills/test-driven-development/SKILL.md
```

### 场景 3：多技能批量本地化

```bash
# 批量处理多个技能目录
for dir in ~/.config/opencode/superpowers ~/.config/opencode/other-skills; do
  cd "$dir"
  git update-index --skip-worktree skills/*/SKILL.md
done
```

## 验证安装

```bash
# 验证 skip-worktree 状态（S = 已设置）
git ls-files -v skills/*/SKILL.md | grep '^S'

# 验证工作树干净
git status

# 验证符号链接存在
ls -la ~/.config/opencode/skills/superpowers
```

## 回滚修改

```bash
# 恢复跟踪
git update-index --no-skip-worktree skills/*/SKILL.md

# 恢复上游版本
git checkout -- skills/*/SKILL.md
```

## 常见错误

### ❌ 错误：创建重复文件

```bash
# 不要这样做 — 你现在维护两份文件
cp ~/.config/opencode/superpowers/skills/*/SKILL.md ~/.config/opencode/skills/
```

### ❌ 错误：使用 assume-unchanged

```bash
# 不要用 --assume-unchanged — 它用于性能优化，不是本地覆盖
git update-index --assume-unchanged skills/*/SKILL.md
```

### ✅ 正确：skip-worktree + 符号链接

```bash
# 原地修改，用 skip-worktree 保护，符号链接用于发现
git update-index --skip-worktree skills/*/SKILL.md
ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers
```

## 技术细节

### skip-worktree vs assume-unchanged

| 标志 | 用途 | 安全用于本地覆盖？ |
|------|------|-------------------|
| `--skip-worktree` | "我本地修改了，不要碰它" | ✅ 是 |
| `--assume-unchanged` | "这个文件很大，跳过性能检查" | ❌ 否 — git 可能覆盖它 |

### YAML Frontmatter 格式

SKILL.md 必须包含 YAML frontmatter 才能被 OpenCode 发现：

```yaml
---
name: your-skill-name
description: 简短描述技能用途和触发条件（会被 OpenCode 展示给用户）
---
```

**错误**：直接以 `# Skill Title` 开头，没有 frontmatter → 技能不被发现。
**正确**：文件必须以 `---` 开头，包含 `name` 和 `description`。

## 项目结构

```
opencode-skill-localizer/
├── README.md              # 本文档
├── skill/
│   └── SKILL.md           # 可安装的 OpenCode 技能文件
├── examples/
│   ├── translate-zh.sh    # 中文翻译示例脚本
│   ├── customize-triggers.sh  # 自定义触发条件示例
│   └── batch-localize.sh  # 批量本地化示例
├── scripts/
│   └── install.sh         # 自动安装脚本
└── docs/
    └── troubleshooting.md # 故障排除指南
```

## 故障排除

### 问题：技能不显示在 OpenCode 中

**原因**：SKILL.md 缺少 YAML frontmatter。
**解决**：确保文件以 `---` 开头，包含 `name` 和 `description`。

### 问题：git pull 后修改丢失

**原因**：未设置 skip-worktree 或使用了 assume-unchanged。
**解决**：重新应用 `git update-index --skip-worktree`。

### 问题：符号链接无效

**原因**：目标目录不存在或路径错误。
**解决**：检查源路径是否正确：`ls -la ~/.config/opencode/skills/superpowers`

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License
