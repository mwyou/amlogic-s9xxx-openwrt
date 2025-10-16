#!/bin/bash
set -e
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Add the default password for the 'root' user（Change the empty password to 'password'）


# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic

#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

ensure_y() {
  sed -i "/^$1[=n|=m]/d" .config
  grep -q "^$1=y" .config || echo "$1=y" >> .config
}
ensure_n() {
  sed -i "/^$1[=y|=m]/d" .config
  grep -q "^$1=n" .config || echo "$1=n" >> .config
}

# 禁用 frp 全家桶
ensure_n CONFIG_PACKAGE_frpc             # frp 客户端，内网穿透
ensure_n CONFIG_PACKAGE_frps             # frp 服务端，内网穿透
ensure_n CONFIG_PACKAGE_luci-app-frpc    # frp 客户端的 LuCI 管理界面
ensure_n CONFIG_PACKAGE_luci-app-frps    # frp 服务端的 LuCI 管理界面

# Argon 主题与配置
ensure_y CONFIG_PACKAGE_luci-theme-argon         # Argon 主题，美化 LuCI
ensure_y CONFIG_PACKAGE_luci-app-argon-config    # Argon 主题配置插件，支持自定义背景等

# Tailscale VPN
ensure_y CONFIG_PACKAGE_tailscale                # Tailscale 主程序，支持 WireGuard Mesh
ensure_y CONFIG_PACKAGE_luci-app-tailscale       # Tailscale 的 LuCI 网页管理插件

# qBittorrent 下载器
ensure_y CONFIG_PACKAGE_qbittorrent              # qBittorrent 主程序，PT/BT 下载
ensure_y CONFIG_PACKAGE_luci-app-qbittorrent     # qBittorrent 的 LuCI 管理界面

# Aria2 下载器
ensure_y CONFIG_PACKAGE_aria2                    # Aria2 多协议下载工具
ensure_y CONFIG_PACKAGE_luci-app-aria2           # Aria2 的 LuCI 管理界面

# WOL Plus 网页唤醒（来自 sundaqiang 源）
ensure_y CONFIG_PACKAGE_luci-app-wolplus         # 网络唤醒插件，批量唤醒局域网设备

# Samba4 文件共享
ensure_y CONFIG_PACKAGE_luci-app-samba4          # Samba4 的 LuCI 管理界面
ensure_y CONFIG_PACKAGE_samba4-server            # Samba4 服务端主程序
ensure_y CONFIG_PACKAGE_samba4-libs              # Samba4 依赖库

# FileBrowser Go 网页文件管理
ensure_y CONFIG_PACKAGE_luci-app-filebrowser-go  # FileBrowser Go 的 LuCI 管理界面
ensure_y CONFIG_PACKAGE_filebrowser-go           # FileBrowser Go 主程序

# OpenList 网页列表管理（来自 sundaqiang 源）
ensure_y CONFIG_PACKAGE_luci-app-openlist        # OpenList 列表管理插件

# 常用基础包
ensure_y CONFIG_PACKAGE_luci                     # LuCI 主界面
ensure_y CONFIG_PACKAGE_luci-ssl                 # LuCI HTTPS 支持
ensure_y CONFIG_PACKAGE_ca-bundle                # CA 根证书包
ensure_y CONFIG_PACKAGE_ca-certificates          # CA 证书包
ensure_y CONFIG_PACKAGE_htop                     # htop 系统资源监控工具

# Podman 容器引擎及相关组件
# ensure_y CONFIG_PACKAGE_podman                   # Podman 主程序，OCI 容器引擎
# ensure_y CONFIG_PACKAGE_conmon                   # Podman 运行时监控
# ensure_y CONFIG_PACKAGE_crun                     # OCI 容器运行时，推荐 crun
# ensure_y CONFIG_PACKAGE_fuse-overlayfs           # 镜像层存储，rootless 支持
# ensure_y CONFIG_PACKAGE_netavark                 # Podman/Netavark 网络组件
# ensure_y CONFIG_PACKAGE_external-protocol        # Podman 网络自动注册到防火墙
# ensure_y CONFIG_PACKAGE_uidmap                   # rootless 支持
# ensure_y CONFIG_PACKAGE_slirp4netns              # rootless 网络支持
# ensure_y CONFIG_PACKAGE_aardvark-dns           # Podman DNS（如 feed 存在则启用）

exit 0
