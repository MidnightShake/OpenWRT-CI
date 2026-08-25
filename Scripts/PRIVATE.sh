#!/bin/bash

# 1. 确定 OpenWrt 源码根目录绝对路径
WRT_DIR="$GITHUB_WORKSPACE/wrt"

# 2. 自动检索 prepare-latest-lucky.sh 的真实位置
LUCKY_SCRIPT=$(find "$WRT_DIR/package/" "$WRT_DIR/feeds/" -type f -name "prepare-latest-lucky.sh" 2>/dev/null | head -n 1)

if [ -n "$LUCKY_SCRIPT" ]; then
    echo ">>> 找到 Lucky 预下载脚本: $LUCKY_SCRIPT"
    echo ">>> 开始预下载 Lucky (arm64) 二进制核心..."
    
    # 确保 OpenWrt 主 dl 目录存在
    mkdir -p "$WRT_DIR/dl"
    
    # 赋予执行权限
    chmod +x "$LUCKY_SCRIPT"
    
    # 修正覆盖设定架构和版本类型
    export LUCKY_CORE_ARCH="arm64"
    export LUCKY_VARIANT="wanji"

    # 覆盖下载脚本 release_subdir
    release_subdir="$(
        printf '%s\n' "$tag_html" |
            grep -Eo "\./[0-9][^\"/]_${LUCKY_VARIANT}/" |
            sed 's#^\./##; s#/$##' |
            grep -v '_docker$' |
            head -n 1 || true
    )"

    # 覆盖下载脚本 source_file
    source_file="$(
        printf '%s\n' "$release_html" |
            grep -Eo "lucky_[^\"<> ]+_Linux_${LUCKY_CORE_ARCH}(_${LUCKY_VARIANT})?\\.tar\\.gz" |
            sort -u |
            head -n 1 || true
    )"
    
    # 执行预下载脚本
    "$LUCKY_SCRIPT" || true
    
    # 核心修补：把下载的核心放到 OpenWrt 主 dl 目录下
    LUCKY_PKG_DIR="$(dirname "$LUCKY_SCRIPT")/.."
    if [ -d "$LUCKY_PKG_DIR/dl" ]; then
        cp -rf "$LUCKY_PKG_DIR/dl/"* "$WRT_DIR/dl/" 2>/dev/null || true
        echo ">>> 已成功同步 Lucky 核心文件到 OpenWrt 主 dl 目录！"
    fi

    # 如果生成了环境变量，导入进来
    if [ -f "$LUCKY_PKG_DIR/.lucky-release.env" ]; then
        source "$LUCKY_PKG_DIR/.lucky-release.env"
        echo ">>> 已加载 Lucky 最新版本信息: ${LUCKY_TAG}"
    fi
    
    echo ">>> Lucky 核心预处理彻底完成！"
else
    echo ">>> 警告: 未找到 prepare-latest-lucky.sh 脚本，请检查 Packages.sh 中 lucky 源码是否正确拉取。"
fi
