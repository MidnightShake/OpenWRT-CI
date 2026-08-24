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

# 高质量<免费>交流群

点击链接加入群聊【IPQ技术讨论群】：https://qm.qq.com/q/v7nMhzB4oU
该群为普通交流群。

# 高质量<付费>中转站

点击链接加入群聊【LiBwrt-Ai学习】：https://qm.qq.com/q/HTa7OiWNCU
该群为AI中转站群。

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

#
[![Stargazers over time](https://starchart.cc/VIKINGYFY/OpenWRT-CI.svg?variant=adaptive)](https://starchart.cc/VIKINGYFY/OpenWRT-CI)
