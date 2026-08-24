#!/bin/bash

# 修正路径：确保在 OpenWrt 源码根目录下找到正确的 dl 目录和 lucky 脚本
WRT_DIR="$GITHUB_WORKSPACE/wrt"

if [ -d "$WRT_DIR/package/luci-app-lucky/scripts" ]; then
    echo ">>> 开始为 Lucky 预下载二进制核心文件到固件的 dl 缓存目录..."
    
    # 确保 dl 目录创建在 OpenWrt 源码根目录下
    mkdir -p "$WRT_DIR/dl"
    
    # 赋予执行权限
    chmod +x "$WRT_DIR/package/luci-app-lucky/scripts/dl_lucky.sh" 2>/dev/null
    
    # 将下载目标目录明确指向 OpenWrt 源码根目录下的 dl/
    "$WRT_DIR/package/luci-app-lucky/scripts/dl_lucky.sh" "$WRT_DIR/dl/" 2>/dev/null || true
    
    echo ">>> Lucky 核心文件预下载完毕！"
fi
