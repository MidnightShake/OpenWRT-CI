#!/bin/bash

# 1. 确定 OpenWrt 源码根目录绝对路径
WRT_DIR="$GITHUB_WORKSPACE/wrt"

# 2. 自动检索 prepare-latest-lucky.sh 的真实位置
LUCKY_SCRIPT=$(find "$WRT_DIR/package/" "$WRT_DIR/feeds/" -type f -name "prepare-latest-lucky.sh" 2>/dev/null | head -n 1)

if [ -n "$LUCKY_SCRIPT" ]; then
    echo ">>> 找到 Lucky 预下载脚本: $LUCKY_SCRIPT"
    echo ">>> 开始预下载 Lucky (aarch64) 二进制核心到 OpenWrt 的 dl 缓存目录..."
    
    # 确保 OpenWrt 的 dl 目录存在
    mkdir -p "$WRT_DIR/dl"
    
    # 赋予执行权限
    chmod +x "$LUCKY_SCRIPT"
    
    # 重点：显式指定为 ARM64 / aarch64 架构，防止默认下载 x86_64 核心
    export LUCKY_CORE_ARCH="aarch64"
    
    # 执行脚本（prepare-latest-lucky.sh 内部会自动把核心推送到 $WRT_DIR/dl 目录）
    "$LUCKY_SCRIPT" || true
    
    echo ">>> Lucky 核心文件预下载完成！"
else
    echo ">>> 警告: 未找到 prepare-latest-lucky.sh 脚本，请检查 Packages.sh 中 lucky 源码是否正确拉取。"
fi
