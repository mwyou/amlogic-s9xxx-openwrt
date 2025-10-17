#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: master
#========================================================================================================================

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# other
# rm -rf package/emortal/{autosamba,ipv6-helper}

set -e
# 追加第三方 feed
grep -q 'sundaqiang/openwrt-packages' feeds.conf.default || \
echo 'src-git sundaqiang https://github.com/sundaqiang/openwrt-packages' >> feeds.conf.default
grep -q 'asvow/luci-app-tailscale' feeds.conf.default || \
echo 'src-git tailscale_luci https://github.com/asvow/luci-app-tailscale.git' >> feeds.conf.default
grep -q 'kenzok8/openwrt-packages' feeds.conf.default || \
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
