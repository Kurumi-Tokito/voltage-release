#!/bin/bash

set -e 

GITPASS=""

# Update & Install Req
sudo apt-get update
echo -ne '\n' | sudo apt-get upgrade -y
echo -ne '\n' | sudo apt-get install git-core git-lfs gnupg ccache flex bison build-essential zip curl zlib1g-dev libssl-dev libc6-dev-i386 libncurses5 x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig -y
sudo ln -s /usr/bin/python3 /usr/bin/python

# create swap
sudo swapon --show
sudo fallocate -l 20G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# ccache
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 50G

# git config
git config --global user.email "93600306+Tokito-Kun@users.noreply.github.com"
git config --global user.name "Tokito-Kun"

# repo
cd ~/
mkdir -p ~/.bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo
export PATH="${HOME}/.bin:${PATH}"

# Fetch Source
mkdir voltageos
cd voltageos
repo init -u https://github.com/VoltageOS/manifest.git -b 13
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
git clone https://$GITPASS@github.com/Tokito-Kun/Private_keys.git keys

# Latest chromium-webview
git clone https://github.com/LineageOS/android_external_chromium-webview_prebuilt_arm -b main external/chromium-webview/prebuilt/arm
git clone https://github.com/LineageOS/android_external_chromium-webview_prebuilt_arm64 -b main external/chromium-webview/prebuilt/arm64
git clone https://github.com/LineageOS/android_external_chromium-webview_prebuilt_x86 -b main external/chromium-webview/prebuilt/x86
git clone https://github.com/LineageOS/android_external_chromium-webview_prebuilt_x86_64 -b main external/chromium-webview/prebuilt/x86_64
cd ~/voltageos/external/chromium-webview/prebuilt/arm  && git lfs pull
cd ~/voltageos/external/chromium-webview/prebuilt/arm64  && git lfs pull
cd ~/voltageos/external/chromium-webview/prebuilt/x86  && git lfs pull
cd ~/voltageos/external/chromium-webview/prebuilt/x86_64  && git lfs pull
cd ~/voltageos

# KProfiles 
git clone https://github.com/CannedShroud/android_packages_apps_KProfiles packages/apps/KProfiles

# Proton Clang
git clone --depth=1  https://github.com/kdrag0n/proton-clang.git prebuilts/clang/host/linux-x86/clang

# Device Tree
git clone --depth=1 --single-branch https://github.com/Tokito-Kun/voltage_device_xiaomi_munch.git -b 13-staging device/xiaomi/munch
# Device-Common Tree
git clone --depth=1 --single-branch https://github.com/Tokito-Kun/voltage_device_xiaomi_sm8250-common.git -b 13-staging device/xiaomi/sm8250-common

# Vendor Tree
git clone --depth=1 https://gitlab.com/pranavtalmale/android_vendor_xiaomi_munch.git -b meme-14 vendor/xiaomi/munch
# Vendor-Common Tree
git clone --depth=1 https://gitlab.com/pranavtalmale/android_vendor_xiaomi_sm8250-common.git -b meme-14 vendor/xiaomi/sm8250-common

# Nexus Kernel
git clone --depth=1 --single-branch https://github.com/Tokito-Kun/nexus_kernel_xiaomi_sm8250 -b voltage-13 kernel/xiaomi/sm8250

. build/envsetup.sh && lunch voltage_munch-eng  && make -j$(nproc --all) target-files-package & make -j$(nproc --all) otatools
#romname=$(cat out/target/product/munch/system/build.prop | grep ro.voltage.version | cut -d "=" -f 2)-$(date -u +%Y%m%d-%H%M)
sign_target_files_apks -o -d keys out/target/product/munch/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip out/target/product/munch/signed-target-files.zip
ota_from_target_files -k keys/releasekey out/target/product/munch/signed-target-files.zip "out/target/product/munch/voltage-2.8-EOL-munch-${date -u +%Y%m%d-%H%M}-UNOFFICIAL.zip"