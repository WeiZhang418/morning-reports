#!/bin/bash
# 自动推送早报到GitHub仓库

cd /Users/zhangwei/WorkBuddy/Claw

# 设置SSH密钥
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_morning"

# 获取最新文件
echo "检查最新的早报文件..."
LATEST_REPORT=$(ls -t market_morning_report_*.html 2>/dev/null | head -1)

if [ -z "$LATEST_REPORT" ]; then
    echo "未找到早报文件"
    exit 1
fi

echo "最新早报: $LATEST_REPORT"

# 添加并提交
git add "$LATEST_REPORT"
git commit -m "早报更新: $LATEST_REPORT" -m "$(date '+%Y-%m-%d %H:%M:%S')"

# 推送到GitHub
git push origin main

echo "✅ 推送完成: https://weizhang418.github.io/morning-reports/$LATEST_REPORT"