# 源自  https://github.com/VIKINGYFY/OpenWRT-CI

# 此为 自用修改版固件

- 工作流仅保留 [`.github/workflows/QCA-ALL.yml`](.github/workflows/QCA-ALL.yml)，只生成包含 `IPQ60XX-WIFI-YES` 的固件
- 目标设备：`link nn6000-v2`（IPQ60XX / ipq6000 平台，含 WIFI），其余设备均不编译
- 默认主题：`luci-theme-argon`
- 仓库纯自用，修改内容未经其它硬件测试

## 固件信息

<!-- FIRMWARE_INFO_START -->
| 项目 | 内容 |
| --- | --- |
| 固件版本 | `IPQ60XX-WIFI-YES-VIKINGYFY-owrt-26.11.05-09.31.28` |
| 编译时间 | 26.11.05-09.31.28（UTC+8） |
| 编译配置 | `IPQ60XX-WIFI-YES` |
| 目标平台 | `qualcommax` |
| 内核版本 | 6.18.55 |
| 源码 | [`VIKINGYFY/immortalwrt`](https://github.com/VIKINGYFY/immortalwrt.git) @ `ec73307` |
| 固件下载 | [Releases](https://github.com/MidnightShake/OpenWRT-CI/releases) |
<!-- FIRMWARE_INFO_END -->

> 以上信息由工作流在编译结束后从本次编译结果自动写入，无需手工维护。

## 重点插件版本

下表由工作流读取本次编译生成的 `.manifest` 自动填充版本号，即当前固件内实际打包的版本。
需要增减条目时改 [`.github/scripts/readme-packages.lst`](.github/scripts/readme-packages.lst) 即可。

<!-- PLUGIN_VERSIONS_START -->
| 分类 | 插件包 | 版本 | 说明 |
| --- | --- | --- | --- |
| 容器 | `docker-compose` | `5.6.1-r1` | Docker Compose 命令行 |
| 容器 | `luci-app-dockerman` | `26.302.04020~df794c7` | Docker 容器管理界面 |
| 容器 | `luci-i18n-dockerman-zh-cn` | `26.302.04020~df794c7` | Docker 管理中文语言包 |
| 内网穿透 | `lucky` | `3.7.1-r1` | Lucky 核心（arm64_wanji 版） |
| 内网穿透 | `luci-app-lucky` | `3.7.1-r1` | Lucky 管理界面 |
| 内网穿透 | `luci-i18n-lucky-zh-cn` | `26.297.58310~94a097f` | Lucky 中文语言包 |
| 代理 | `luci-app-openclash` | `0.48.002` | OpenClash 科学上网客户端 |
| DNS | `mosdns` | `5.3.3-r1` | mosdns 核心 |
| DNS | `luci-app-mosdns` | `1.7.15-r1` | mosdns 管理界面 |
| DNS | `luci-i18n-mosdns-zh-cn` | `26.298.37786~dbdd91a` | mosdns 中文语言包 |
| 远程访问 | `tailscale` | `1.104.1-r2` | Tailscale 组网核心 |
| 远程访问 | `luci-app-tailscale-community` | `26.302.04020~df794c7` | Tailscale 管理界面 |
| 远程访问 | `luci-i18n-tailscale-community-zh-cn` | `26.302.04020~df794c7` | Tailscale 中文语言包 |
| 主题 | `luci-theme-argon` | `3.1.0-r20261022` | Argon 默认主题 |
| 主题 | `luci-app-argon-config` | 未包含 | Argon 主题配置 |
| 主题 | `luci-i18n-argon-config-zh-cn` | `26.251.59830~4b8b784` | Argon 主题配置中文语言包 |
| 存储 | `luci-app-mini-diskmanager` | `1.0.29-r20260215` | 磁盘管理 |
| 存储 | `luci-app-samba4` | `26.302.04020~df794c7` | SMB 网络共享 |
| 网络 | `luci-app-upnp` | `26.302.04020~df794c7` | UPnP 端口自动映射 |
| 网络 | `luci-app-natmapt` | 未包含 | NAT 穿透辅助 |
| 系统 | `luci-app-autoreboot` | `26.302.04020~df794c7` | 定时重启 |
| 系统 | `luci-app-partexp` | `2.0.5-r20260318` | 分区自动扩容 |
| 系统 | `luci-app-wolultra` | `20261016-r1` | 网络唤醒 |
| 系统 | `luci-app-gecoosac` | `20261016-r1` | 广电宽带认证 |
<!-- PLUGIN_VERSIONS_END -->

> 显示「未包含」表示该插件在当前源码/配置下没有真正编译进固件（配置里写了 `=y` 但仓库中找不到对应软件包时会出现），可据此排查。

<details>
<summary>全部 LuCI 插件清单（自动生成）</summary>

<!-- ALL_PLUGINS_START -->
| 插件包 | 版本 |
| --- | --- |
| `luci-app-autoreboot` | 26.302.04020~df794c7 |
| `luci-app-dockerman` | 26.302.04020~df794c7 |
| `luci-app-firewall` | 26.302.04020~df794c7 |
| `luci-app-fullconenat-sonic` | 20261016-r1 |
| `luci-app-gecoosac` | 20261016-r1 |
| `luci-app-lucky` | 3.7.1-r1 |
| `luci-app-mini-diskmanager` | 1.0.29-r20260215 |
| `luci-app-mosdns` | 1.7.15-r1 |
| `luci-app-openclash` | 0.48.002 |
| `luci-app-package-manager` | 26.302.04020~df794c7 |
| `luci-app-partexp` | 2.0.5-r20260318 |
| `luci-app-qca-ppe-qos` | 20261102-r1 |
| `luci-app-router-tool` | 20261103-r1 |
| `luci-app-samba4` | 26.302.04020~df794c7 |
| `luci-app-tailscale-community` | 26.302.04020~df794c7 |
| `luci-app-upnp` | 26.302.04020~df794c7 |
| `luci-app-wolultra` | 20261016-r1 |
| `luci-proto-ipv6` | 26.302.04020~df794c7 |
| `luci-proto-ppp` | 26.302.04020~df794c7 |
| `luci-proto-relay` | 26.302.04020~df794c7 |
| `luci-theme-argon` | 3.1.0-r20261022 |
<!-- ALL_PLUGINS_END -->

</details>

## 相对上游的插件改动

### 增加 / 替换

- **Docker**：`luci-app-dockerman`、`luci-i18n-dockerman-zh-cn`、`docker-compose`
  - 来源：上游 feeds
- **Lucky**：`lucky`、`luci-app-lucky`、`luci-i18n-lucky-zh-cn`
  - 来源：https://github.com/MidnightShake/luci-app-lucky
  - 编译进固件的是 `arm64_wanji` 核心，核心下载源自 https://release.66666.host
  - 由 [Scripts/PRIVATE.sh](Scripts/PRIVATE.sh) 预下载核心并放入 `dl` 目录
- **科学上网**：由 `luci-app-homeproxy` 调整为 `luci-app-openclash`
  - 来源：上游 feeds
- **mosdns**：`mosdns`、`luci-app-mosdns`、`luci-i18n-mosdns-zh-cn`
  - 来源：上游 feeds（已处理与 `luci-app-mosdns` 的 init 脚本冲突）
- **Tailscale**：`tailscale`、`luci-app-tailscale-community`、`luci-i18n-tailscale-community-zh-cn`
  - 来源：https://github.com/asvow/luci-app-tailscale
- **主题**：`luci-theme-argon`、`luci-app-argon-config`、`luci-i18n-argon-config-zh-cn`
  - 来源：https://github.com/sbwml/luci-theme-argon
- **其它**：`luci-app-autoreboot`、`luci-app-samba4`、`luci-app-upnp`、`luci-app-natmapt`、`luci-app-partexp`、`luci-app-wolultra`、`luci-app-gecoosac`、`luci-app-mini-diskmanager`
  - 来源：上游 feeds

### 移除

- `luci-app-attendedsysupgrade`、`luci-app-wol`

### 内核与组件

- 完整列表见 [Config/GENERAL.txt](Config/GENERAL.txt)：Docker、USB 网卡/存储、Btrfs、NVMe、nftables（tproxy/offload/queue 等）、WireGuard、mptcp、bonding 等内核模块

## 目录简要说明

- `.github/workflows`：自定义 CI 配置（仅 `QCA-ALL`、`WRT-CORE`、`Auto-Clean`、`Cache-Clean`、`WRT-TEST`）
- `.github/scripts`：构建辅助脚本，以及本文档的自动更新脚本 `update-readme.sh`
- `Scripts`：自定义脚本（`Packages.sh` 拉取插件、`Handles.sh` 打补丁、`Settings.sh` 改默认值、`PRIVATE.sh` 私有处理）
- `Config`：自定义编译配置

# 修改内容未经其它硬件测试

<!-- UPSTREAM_README_START -->
# 上游源 README.md 内容：

# 高质量<免费>交流群

[IPQ技术讨论群](https://qm.qq.com/q/v7nMhzB4oU)

# 高质量<付费>中转站

[Krill-Code](https://www.krill-code.com/register?invite=959NHQCZGT)

# 本地编译器

https://github.com/VIKINGYFY/OWRT-Tools.git

# 自用修改版插件

https://github.com/VIKINGYFY/packages.git

# OpenWRT-CI

官方版：

https://github.com/immortalwrt/immortalwrt.git

自用版：

https://github.com/VIKINGYFY/immortalwrt.git

# U-BOOT

高通版-沉心：

https://github.com/chenxin527/uboot-qsdk12.5-build.git

高通版-小猪：

https://github.com/1980490718/u-boot-2016.git

联发科-全新版：

https://github.com/VIKINGYFY/UBOOT-CI/releases

联发科-官方版：

https://drive.wrt.moe/uboot/mediatek

# 固件简要说明

固件每天早上5点自动编译。

固件信息里的时间为编译开始的时间，方便核对上游源码提交时间。

MEDIATEK系列、QUALCOMMAX系列、ROCKCHIP系列、X86系列。

# 目录简要说明

workflows——自定义CI配置

Scripts——自定义脚本

Config——自定义配置

## Star History

<a href="https://www.star-history.com/?repos=vikingyfy%2Fopenwrt-ci&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=vikingyfy/openwrt-ci&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=vikingyfy/openwrt-ci&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=vikingyfy/openwrt-ci&type=date&legend=top-left" />
 </picture>
</a>
<!-- UPSTREAM_README_END -->
