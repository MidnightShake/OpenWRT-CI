#!/bin/bash
# SPDX-License-Identifier: MIT
# 维护 README.md：同步上游 README、刷新「固件信息」「插件版本」「全部插件」区块
#
# 用法（工作目录 = 本仓库根目录）：
#   .github/scripts/update-readme.sh
#
# 环境变量：
#   GITHUB_WORKSPACE   仓库根目录（默认取脚本上两级目录）
#   WRT_BUILD_DIR      OpenWrt 源码目录（默认 $GITHUB_WORKSPACE/wrt）
#   WRT_MANIFEST       直接指定 .manifest 路径（可选，默认自动查找）
#   README_PKG_LIST    需要重点展示版本的插件清单（默认 .github/scripts/readme-packages.lst）
#   README_UPSTREAM_URL 上游 README 地址（默认 VIKINGYFY/OpenWRT-CI 的 main 分支）
#   README_NO_PUSH     设为 1 时只更新文件、不提交推送（本地调试用）
#
# 说明：脚本只替换 README 中 START/END 注释标记之间的内容，
#       标记缺失或内容没有变化时都不会破坏/覆盖 README。

set -euo pipefail

WORKSPACE="${GITHUB_WORKSPACE:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
README="$WORKSPACE/README.md"
BUILD_DIR="${WRT_BUILD_DIR:-$WORKSPACE/wrt}"
PKG_LIST="${README_PKG_LIST:-$WORKSPACE/.github/scripts/readme-packages.lst}"
UPSTREAM_URL="${README_UPSTREAM_URL:-https://raw.githubusercontent.com/VIKINGYFY/OpenWRT-CI/main/README.md}"

START_UPSTREAM='<!-- UPSTREAM_README_START -->'
END_UPSTREAM='<!-- UPSTREAM_README_END -->'
START_INFO='<!-- FIRMWARE_INFO_START -->'
END_INFO='<!-- FIRMWARE_INFO_END -->'
START_PKGS='<!-- PLUGIN_VERSIONS_START -->'
END_PKGS='<!-- PLUGIN_VERSIONS_END -->'
START_ALL='<!-- ALL_PLUGINS_START -->'
END_ALL='<!-- ALL_PLUGINS_END -->'

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

log() { printf '>>> %s\n' "$*"; }
warn() { printf '>>> WARNING: %s\n' "$*" >&2; }

trim() {
	local S=$1
	S="${S#"${S%%[![:space:]]*}"}"
	S="${S%"${S##*[![:space:]]}"}"
	printf '%s' "$S"
}

# 用 $CONTENT 文件的内容替换 $FILE 中 $START/$END 标记之间的内容（保留标记本身）
# 返回 0 = 已替换，3 = 缺少标记，其他 = awk 失败
replace_block() {
	local FILE=$1 START=$2 END=$3 CONTENT=$4
	local OUT="$TMP_DIR/replace.out"
	[ -f "$CONTENT" ] || { warn "内容文件不存在：$CONTENT"; return 4; }
	awk -v start="$START" -v end="$END" -v content="$CONTENT" '
		$0 == start {
			print
			while ((getline line < content) > 0) print line
			close(content)
			inside = 1
			seen = 1
			next
		}
		$0 == end { print; inside = 0; next }
		!inside
		END { exit(seen ? 0 : 3) }
	' "$FILE" > "$OUT" || return $?
	mv -- "$OUT" "$FILE"
}

[ -f "$README" ] || { warn "README 不存在：$README"; exit 1; }

# ---------------------------------------------------------------- manifest
# 查找顺序：显式指定的 WRT_MANIFEST → 打包步骤另存的副本 →
#           release 上传目录 upload/ → 源码目录 bin/targets（未被清理时）
resolve_manifest() {
	local CANDIDATE
	for CANDIDATE in \
		"${WRT_MANIFEST:-}" \
		"$WORKSPACE/build-reports/firmware.manifest"; do
		[ -n "$CANDIDATE" ] && [ -f "$CANDIDATE" ] && { printf '%s' "$CANDIDATE"; return 0; }
	done
	# 打包步骤会把 manifest 移动/改名到 upload/ 后再执行 make clean
	if [ -d "$BUILD_DIR/upload" ]; then
		CANDIDATE=$(find "$BUILD_DIR/upload" -maxdepth 2 -type f -name '*.manifest' 2>/dev/null | sort | head -n 1)
		if [ -n "$CANDIDATE" ]; then
			printf '%s' "$CANDIDATE"
			return 0
		fi
	fi

	find "$BUILD_DIR/bin/targets" -type f -name '*.manifest' 2>/dev/null | sort | head -n 1
}

MANIFEST=$(resolve_manifest || true)
if [ -n "$MANIFEST" ] && [ -f "$MANIFEST" ]; then
	log "使用 manifest：${MANIFEST#"$WORKSPACE"/}"
else
	MANIFEST=""
	warn "未找到 .manifest 文件，插件版本将标记为「未包含」"
fi

# 从 manifest 读取包版本，兼容 "pkg - version" 与 "pkg version" 两种格式
manifest_version() {
	local PKG=$1
	[ -n "$MANIFEST" ] || return 0
	awk -v pkg="$PKG" '
		$1 == pkg {
			if ($2 == "-") sub(/^[^[:space:]]+ - /, "")
			else sub(/^[^[:space:]]+ /, "")
			print
			exit
		}
	' "$MANIFEST"
}

# ------------------------------------------------------------ 固件信息区块
write_firmware_info() {
	local OUT=$1
	local KVER
	KVER=$(printf '%s' "${WRT_KVER:-}" | head -n 1)
	local SOURCE="${WRT_SOURCE:-未知}"
	local COMMIT="${WRT_HASH:-未知}"
	local REPO="${WRT_REPO:-}"
	local SOURCE_CELL
	if [ -n "$REPO" ]; then
		SOURCE_CELL="[\`$SOURCE\`]($REPO) @ \`$COMMIT\`"
	else
		SOURCE_CELL="\`$SOURCE\` @ \`$COMMIT\`"
	fi

	{
		printf '| 项目 | 内容 |\n'
		printf '| --- | --- |\n'
		printf '| 固件版本 | `%s` |\n' "${WRT_CONFIG:-未知}-${WRT_INFO:-未知}-${WRT_BRANCH:-未知}-${WRT_DATE:-未知}"
		printf '| 编译时间 | %s（UTC+8） |\n' "${WRT_DATE:-未知}"
		printf '| 编译配置 | `%s` |\n' "${WRT_CONFIG:-未知}"
		printf '| 目标平台 | `%s` |\n' "${WRT_TARGET:-未知}"
		printf '| 内核版本 | %s |\n' "${KVER:-未知}"
		printf '| 源码 | %s |\n' "$SOURCE_CELL"
		printf '| 固件下载 | [Releases](https://github.com/%s/releases) |\n' "${GITHUB_REPOSITORY:-MidnightShake/OpenWRT-CI}"
	} > "$OUT"
}

# -------------------------------------------------------- 重点插件版本区块
write_plugin_versions() {
	local OUT=$1
	local COUNT=0
	local PKG CATEGORY DESC VERSION CELL_VERSION

	{
		printf '| 分类 | 插件包 | 版本 | 说明 |\n'
		printf '| --- | --- | --- | --- |\n'
	} > "$OUT"

	if [ -f "$PKG_LIST" ]; then
		while IFS='|' read -r PKG CATEGORY DESC; do
			PKG=$(trim "${PKG:-}")
			[ -n "$PKG" ] || continue
			case "$PKG" in \#*) continue ;; esac   # 以 # 开头的是注释
			CATEGORY=$(trim "${CATEGORY:-}")
			DESC=$(trim "${DESC:-}")
			VERSION=$(manifest_version "$PKG")
			if [ -n "$VERSION" ]; then
				CELL_VERSION="\`$VERSION\`"
			else
				CELL_VERSION="未包含"
			fi
			printf '| %s | `%s` | %s | %s |\n' "$CATEGORY" "$PKG" "$CELL_VERSION" "$DESC" >> "$OUT"
			COUNT=$((COUNT + 1))
		done < <(grep -v '^[[:space:]]*$' "$PKG_LIST" || true)
	else
		warn "插件清单不存在：$PKG_LIST"
	fi

	log "重点插件：$COUNT 项"
}

# ------------------------------------------------------ 全部 LuCI 插件区块
write_all_plugins() {
	local OUT=$1
	local COUNT=0

	printf '| 插件包 | 版本 |\n| --- | --- |\n' > "$OUT"
	if [ -n "$MANIFEST" ]; then
		awk '
			{
				name = $1
				if (name !~ /^luci-(app|theme|proto)-/) next
				if ($2 == "-") sub(/^[^[:space:]]+ - /, "")
				else sub(/^[^[:space:]]+ /, "")
				printf "| `%s` | %s |\n", name, $0
			}
		' "$MANIFEST" | LC_ALL=C sort -u >> "$OUT"
		COUNT=$(($(wc -l < "$OUT") - 2))
	fi

	log "全部 LuCI 插件：$COUNT 项"
}

# ------------------------------------------------------------ 上游 README
if curl -fsSL --retry 2 --max-time 60 "$UPSTREAM_URL" -o "$TMP_DIR/upstream.md" 2>/dev/null &&
	[ -s "$TMP_DIR/upstream.md" ]; then
	{
		printf '# 上游源 README.md 内容：\n\n'
		cat "$TMP_DIR/upstream.md"
	} > "$TMP_DIR/upstream_block.md"
	if replace_block "$README" "$START_UPSTREAM" "$END_UPSTREAM" "$TMP_DIR/upstream_block.md"; then
		log "已同步上游 README"
	else
		warn "README 缺少 $START_UPSTREAM / $END_UPSTREAM 标记，跳过上游 README 同步"
	fi
else
	warn "抓取上游 README 失败，保留原有内容"
fi

# --------------------------------------------------------- 写入各内容区块
INFO_FILE="$TMP_DIR/firmware_info.md"
write_firmware_info "$INFO_FILE"
if replace_block "$README" "$START_INFO" "$END_INFO" "$INFO_FILE"; then
	log "已更新固件信息"
else
	warn "README 缺少 $START_INFO / $END_INFO 标记，跳过固件信息"
fi

PKGS_FILE="$TMP_DIR/plugin_versions.md"
write_plugin_versions "$PKGS_FILE"
if replace_block "$README" "$START_PKGS" "$END_PKGS" "$PKGS_FILE"; then
	log "已更新重点插件版本"
else
	warn "README 缺少 $START_PKGS / $END_PKGS 标记，跳过重点插件版本"
fi

ALL_FILE="$TMP_DIR/all_plugins.md"
write_all_plugins "$ALL_FILE"
if replace_block "$README" "$START_ALL" "$END_ALL" "$ALL_FILE"; then
	log "已更新全部插件清单"
else
	warn "README 缺少 $START_ALL / $END_ALL 标记，跳过全部插件清单"
fi

# ------------------------------------------------------------- 提交推送
if [ "${README_NO_PUSH:-0}" = "1" ]; then
	log "README_NO_PUSH=1，跳过提交推送"
	exit 0
fi

cd "$WORKSPACE"

# 只在 git 仓库内提交；使用仓库级身份，避免污染开发机的全局 git 配置
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	warn "README 已更新，但 $WORKSPACE 不是 git 仓库，跳过提交推送"
	exit 0
fi

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

if git diff --quiet -- README.md; then
	log "README.md 无变动，跳过推送"
	exit 0
fi

git add README.md
git commit -m "auto: 同步上游 README 并更新固件信息与插件版本清单 [skip ci]"
git push
log "README.md 已更新并推送"
