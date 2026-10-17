#!/bin/bash -e

# ============================================================================================================
# 自定义DIY⬇⬇⬇
# TTYD
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# default LAN IP
sed -i "s/192.168.1.1/192.168.5.88/g" package/base-files/files/bin/config_generate

# golang 1.27
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 27.x feeds/packages/lang/golang

# node - prebuilt
rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node -b packages-24.10 feeds/packages/lang/node

# zerotier
rm -rf feeds/packages/net/zerotier
git clone https://github.com/sbwml/feeds_packages_net_zerotier feeds/packages/net/zerotier

# 移除待替换插件
rm -rf feeds/packages/net/{openlist,lucky}
rm -rf feeds/packages/utils/filebrowser
rm -rf feeds/luci/applications/luci-app-{passwall,openclash,zerotier,openlist,filebrowser,lucky,filebrowser-go}

# Git稀疏克隆，只克隆指定目录到package/new
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package/new
  cd .. && rm -rf $repodir
}

# 常见插件
git_sparse_clone main https://github.com/sbwml/openwrt_pkgs luci-app-zerotier
git_sparse_clone main https://github.com/Kwonelee/openwrt-packages filebrowser luci-app-filebrowser-go
FB_VERSION="$(curl -s https://github.com/filebrowser/filebrowser/tags | grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 | sed 's/^v//')"
sed -i "s/2.54.0/$FB_VERSION/g" package/new/filebrowser/Makefile
# 自定义DIY⬆⬆⬆
# ============================================================================================================
