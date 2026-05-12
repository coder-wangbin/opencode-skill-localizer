# Troubleshooting Guide

## 技能不显示在 OpenCode 中

### 症状
使用 `/skill-name` 命令时，技能未出现在列表中。

### 可能原因

1. **SKILL.md 缺少 YAML frontmatter**
   ```bash
   # 检查文件开头是否有 ---
   head -5 ~/.config/opencode/skills/your-skill/SKILL.md
   ```
   **修复**：确保文件以 `---` 开头，包含 `name` 和 `description`。

2. **符号链接路径错误**
   ```bash
   # 检查符号链接是否有效
   ls -la ~/.config/opencode/skills/your-skill
   ```
   **修复**：重新创建符号链接：
   ```bash
   ln -sf /correct/source/path ~/.config/opencode/skills/your-skill
   ```

3. **OpenCode 未重启**
   技能发现发生在启动时。重启 OpenCode 后重试。

## git pull 后修改丢失

### 症状
执行 `git pull` 后，本地化的技能描述被覆盖。

### 原因
未设置 `skip-worktree` 或错误使用了 `assume-unchanged`。

### 修复
```bash
cd ~/.config/opencode/superpowers
git update-index --skip-worktree skills/*/SKILL.md
```

### 预防
每次修改技能文件后，立即应用 `skip-worktree`。

## 符号链接无效

### 症状
`ls -la ~/.config/opencode/skills/superpowers` 显示红色闪烁的链接。

### 原因
目标路径不存在或拼写错误。

### 修复
```bash
# 检查源路径
ls -la ~/.config/opencode/superpowers/skills

# 重新创建符号链接
rm ~/.config/opencode/skills/superpowers
ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers
```

## 批量翻译脚本失败

### 症状
运行 `translate-zh.sh` 时出现 `sed: invalid option` 错误。

### 原因
macOS 和 Linux 的 `sed` 语法不同。

### 修复
- **macOS**：使用 `sed -i ''`
- **Linux**：使用 `sed -i`

修改脚本中的 `sed` 命令以匹配你的系统。

## 多个技能目录冲突

### 症状
不同来源的技能覆盖彼此。

### 解决方案
为每个技能目录单独应用 `skip-worktree`：
```bash
for dir in ~/.config/opencode/superpowers ~/.config/opencode/other-skills; do
    cd "$dir"
    git update-index --skip-worktree skills/*/SKILL.md
done
```
