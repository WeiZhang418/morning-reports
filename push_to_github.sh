#!/bin/bash
# 自动推送早报到GitHub仓库

cd /Users/zhangwei/WorkBuddy/Claw

# 设置SSH密钥
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_morning"

# 获取今天日期的早报文件
TODAY=$(date '+%Y%m%d')
TODAY_REPORT="market_morning_report_${TODAY}.html"

echo "检查今日早报文件: $TODAY_REPORT"

# 如果今天有早报文件，优先推今天的
if [ -f "$TODAY_REPORT" ]; then
    LATEST_REPORT="$TODAY_REPORT"
    echo "找到今日早报: $LATEST_REPORT"
else
    # 否则找最新的早报文件
    echo "未找到今日早报，查找最新文件..."
    LATEST_REPORT=$(ls -t market_morning_report_*.html 2>/dev/null | head -1)
    
    if [ -z "$LATEST_REPORT" ]; then
        echo "未找到任何早报文件"
        exit 1
    fi
    echo "使用最新早报: $LATEST_REPORT"
fi

# 添加并提交
git add "$LATEST_REPORT"
git commit -m "早报更新: $LATEST_REPORT" -m "自动推送于 $(date '+%Y-%m-%d %H:%M:%S')"

# 推送到GitHub
echo "正在推送到GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ 推送完成: https://weizhang418.github.io/morning-reports/$LATEST_REPORT"
    echo "📱 手机访问: 用浏览器打开上述链接即可查看"
else
    echo "❌ 推送失败"
    exit 1
fi