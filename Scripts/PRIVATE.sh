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
    export LUCKY_VARIANT="wanji"  # 空值为lucky默认版
    
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

# 修复 mosdns 与 luci-app-mosdns 同时安装 /etc/init.d/mosdns 的冲突
# 让 mosdns 继续持有 init 脚本，luci-app-mosdns 只保留 LuCI 界面和配置
PATCH_MOSDNS_INIT_CONFLICT() {
    local CANDIDATE_DIRS=(
        "$WRT_DIR/package/luci-app-mosdns"
        "$GITHUB_WORKSPACE/package/luci-app-mosdns"
        "./package/luci-app-mosdns"
    )

    local PKG_DIR=""
    for d in "${CANDIDATE_DIRS[@]}"; do
        if [ -d "$d" ]; then
            PKG_DIR="$d"
            break
        fi
    done

    if [ -z "$PKG_DIR" ]; then
        echo "[mosdns-fix] luci-app-mosdns not found, skip."
        return 0
    fi

    echo "[mosdns-fix] patching $PKG_DIR"

    # 删除重复的 init 脚本文件
    find "$PKG_DIR" \
        -type f \
        \( -path "*/etc/init.d/mosdns" -o -path "*/files/mosdns.init" -o -path "*/root/etc/init.d/mosdns" \) \
        -exec rm -f {} \; 2>/dev/null || true

    # 删除 Makefile 里重复安装 init 脚本的规则
    while IFS= read -r mf; do
        [ -n "$mf" ] || continue
        sed -i '/\/etc\/init.d\/mosdns/d; /mosdns.init/d' "$mf" 2>/dev/null || true
    done < <(find "$PKG_DIR" -type f \( -name 'Makefile' -o -name '*.mk' \) -print 2>/dev/null)

    # 清理常见重复目录
    rm -rf "$PKG_DIR"/root/etc/init.d "$PKG_DIR"/etc/init.d "$PKG_DIR"/files 2>/dev/null || true

    echo "[mosdns-fix] Removed duplicate mosdns init ownership from luci-app-mosdns"
}

PATCH_MOSDNS_INIT_CONFLICT
