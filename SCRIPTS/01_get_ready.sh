#!/bin/bash -e

# 一些处理
cp -f $GITHUB_WORKSPACE/FILES/banner package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/FILES/target.mk include/target.mk
sed -i "s/hostname='LEDE'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate
#sed -i 's/default "LEDE"/default "OpenWrt"/g' package/base-files/image-config.in
sed -i 's/LEDE/OpenWrt/g' package/base-files/image-config.in
sed -i 's/lede/openwrt/g' package/base-files/image-config.in
sed -i 's/LEDE/OpenWrt/g' package/lean/default-settings/files/zzz-default-settings

# 使用6.18内核
#sed -i "s/6.12/6.18/g" target/linux/rockchip/Makefile
