#!/bin/bash
# 自动推送早报/晚报到GitHub仓库

cd /Users/zhangwei/WorkBuddy/Claw

# 设置SSH密钥
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_morning"

TODAY=$(date '+%Y%m%d')
FILES_TO_ADD=""
COMMIT_MSG_PARTS=""

# ---- 早报 ----
MORNING_FILE="market_morning_report_${TODAY}.html"
if [ -f "$MORNING_FILE" ]; then
    FILES_TO_ADD="$FILES_TO_ADD $MORNING_FILE"
    COMMIT_MSG_PARTS="早报 $MORNING_FILE"
    echo "✅ 找到今日早报: $MORNING_FILE"
else
    LATEST_MORNING=$(ls -t market_morning_report_*.html 2>/dev/null | head -1)
    if [ -n "$LATEST_MORNING" ]; then
        FILES_TO_ADD="$FILES_TO_ADD $LATEST_MORNING"
        COMMIT_MSG_PARTS="最新早报 $LATEST_MORNING"
        echo "ℹ️  未找到今日早报，使用最新: $LATEST_MORNING"
    fi
fi

# ---- 晚报 ----
EVENING_FILE="market_evening_report_${TODAY}.html"
if [ -f "$EVENING_FILE" ]; then
    FILES_TO_ADD="$FILES_TO_ADD $EVENING_FILE"
    COMMIT_MSG_PARTS="$COMMIT_MSG_PARTS 晚报 $EVENING_FILE"
    echo "✅ 找到今日晚报: $EVENING_FILE"
else
    LATEST_EVENING=$(ls -t market_evening_report_*.html 2>/dev/null | head -1)
    if [ -n "$LATEST_EVENING" ]; then
        FILES_TO_ADD="$FILES_TO_ADD $LATEST_EVENING"
        COMMIT_MSG_PARTS="$COMMIT_MSG_PARTS 最新晚报 $LATEST_EVENING"
        echo "ℹ️  未找到今日晚报，使用最新: $LATEST_EVENING"
    fi
fi

if [ -z "$FILES_TO_ADD" ]; then
    echo "❌ 未找到任何早报或晚报文件，退出"
    exit 1
fi

# ---- 提交 ----
git add $FILES_TO_ADD index.html
git commit -m "报告更新: $COMMIT_MSG_PARTS" -m "自动推送于 $(date '+%Y-%m-%d %H:%M:%S')"

# ---- 推送 ----
echo "正在推送到GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 推送完成！GitHub Pages 链接："
    [ -f "$MORNING_FILE" ] && echo "  📰 早报: https://weizhang418.github.io/morning-reports/$MORNING_FILE"
    [ -f "$EVENING_FILE" ] && echo "  🌙 晚报: https://weizhang418.github.io/morning-reports/$EVENING_FILE"
    echo "📱 手机浏览器打开以上链接即可访问"
else
    echo "❌ 推送失败"
    exit 1
fi