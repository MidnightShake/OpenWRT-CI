#!/bin/bash

# 1. 确定 OpenWrt 源码根目录绝对路径
WRT_DIR="$GITHUB_WORKSPACE/wrt"

# 2. 自动检索 prepare-latest-lucky.sh 的真实位置
LUCKY_SCRIPT=$(find "$WRT_DIR/package/" "$WRT_DIR/feeds/" -type f -name "prepare-latest-lucky.sh" 2>/dev/null | head -n 1)

if [ -n "$LUCKY_SCRIPT" ]; then
    echo ">>> 找到 Lucky 预下载脚本: $LUCKY_SCRIPT"
    echo ">>> 开始预下载 Lucky (aarch64) 二进制核心..."
    
    # 确保 OpenWrt 主 dl 目录存在
    mkdir -p "$WRT_DIR/dl"
    
    # 赋予执行权限
    chmod +x "$LUCKY_SCRIPT"
    
    # 显式传递参数
    export LUCKY_CORE_ARCH="aarch64"
    
    # 执行脚本
    "$LUCKY_SCRIPT" || true
    
    # 核心修补：把脚本下载到相对目录 (package/luci-app-lucky/dl/) 里的文件复制到 OpenWrt 主 dl 目录下
    LUCKY_PKG_DIR="$(dirname "$LUCKY_SCRIPT")/.."
    if [ -d "$LUCKY_PKG_DIR/dl" ]; then
        cp -rf "$LUCKY_PKG_DIR/dl/"* "$WRT_DIR/dl/" 2>/dev/null || true
        echo ">>> 已成功同步 Lucky 核心文件到 OpenWrt 主 dl 目录！"
    fi
    
    echo ">>> Lucky 核心预处理彻底完成！"
else
    echo ">>> 警告: 未找到 prepare-latest-lucky.sh 脚本，请检查 Packages.sh 中 lucky 源码是否正确拉取。"
fi
