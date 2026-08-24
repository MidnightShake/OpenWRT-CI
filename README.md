# 源自  https://github.com/VIKINGYFY/OpenWRT-CI

# 此为 自用修改版固件
  - 工作流仅保留生成包含 IPQ60XX-WIFI-YES ： link nn600v2 ipq6000 框架平台固件
  - 工作流仅.github/workflows/QCA-ALL.yml IPQ60XX-WIFI-YES 相关

# 固件插件修改内容包括：
  - 增加：luci-app-dockerman  luci-i18n-dockerman-zh-cn  docker-compose
    - 来源：上游官方
    
  - 增加：lucky  luci-app-lucky  luci-i18n-lucky-zh-cn
    - 来源：https://github.com/FloatingDream528/luci-app-lucky
    - 当前加入编译固件信息（arm64）：
      - 核心源自：https://release.66666.host
<!-- LUCKY_VERSION_START -->
      - lucky - 3.0.0_beta8-r1
      - luci-app-lucky - 3.0.0_beta8-r1
      - luci-i18n-lucky-zh-cn - 26.205.10034~ed6ebfc
<!-- LUCKY_VERSION_END -->
      
  - 科学插件由 luci-app-homeproxy 调整为：luci-app-openclash
    - 来源：上游官方

# 修改内容未经其它硬件测试




# 上游源 README.md 内容：

<!-- UPSTREAM_README_START -->
<!-- 编译时自动同步 VIKINGYFY/OpenWRT-CI 的 README.md -->
<!-- UPSTREAM_README_END -->
