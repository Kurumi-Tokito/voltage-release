#!/bin/bash

set -e

GITPASS=""

# Update & Install Req
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git-core git-lfs jq gnupg ccache flex bison build-essential zip curl zlib1g-dev libssl-dev libc6-dev-i386 libncurses5 x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig -y
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
rm -rf external/chromium-webview/prebuilt/arm
rm -rf external/chromium-webview/prebuilt/arm64
rm -rf external/chromium-webview/prebuilt/x86
rm -rf external/chromium-webview/prebuilt/x86_64
git clone https://github.com/LineageOS/android_external_chromium-webview_prebuilt_arm.git -b main external/chromium-webview/prebuilt/arm
git clone https://github.com/LineageOS/android_external_chromium-webview_prebuilt_arm64.git -b main external/chromium-webview/prebuilt/arm64
git clone https://github.com/LineageOS/android_external_chromium-webview_prebuilt_x86.git -b main external/chromium-webview/prebuilt/x86
git clone https://github.com/LineageOS/android_external_chromium-webview_prebuilt_x86_64.git -b main external/chromium-webview/prebuilt/x86_64
cd ~/voltageos/external/chromium-webview/prebuilt/arm  && git lfs pull
cd ~/voltageos/external/chromium-webview/prebuilt/arm64  && git lfs pull
cd ~/voltageos/external/chromium-webview/prebuilt/x86  && git lfs pull
cd ~/voltageos/external/chromium-webview/prebuilt/x86_64  && git lfs pull
cd ~/voltageos

# Smart 5G patch
rm -r frameworks/base
git clone --single-branch https://github.com/Tokito-Kun/voltage_frameworks_base.git -b 13 frameworks/base

rm -r packages/apps/Settings
git clone --single-branch https://github.com/Tokito-Kun/voltage_packages_apps_Settings.git -b 13 packages/apps/Settings

# Some Dolby Patches from Pranav-Talmale
rm -r frameworks/av
git clone --single-branch https://github.com/Pranav-Talmale/vos_frameworks_av.git -b 13 frameworks/av

# KProfiles
git clone https://github.com/KProfiles/android_packages_apps_Kprofiles packages/apps/KProfiles

# Prebuilt apps
git clone --depth=1 --single-branch https://github.com/Tokito-Kun/android_packages_apps_Prebuilts.git -b 13 package/apps/Prebuilts

# slim Clang
git clone --depth=1 https://gitlab.com/ThankYouMario/android_prebuilts_clang-standalone -b slim-16 prebuilts/clang/host/linux-x86/clangB
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git gcc
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9.git gcc32

# Device Tree
git clone --depth=1 --single-branch https://github.com/Tokito-Kun/voltage_device_xiaomi_munch.git -b 13-staging device/xiaomi/munch
# Device-Common Tree
git clone --depth=1 --single-branch https://github.com/Tokito-Kun/voltage_device_xiaomi_sm8250-common.git -b 13-staging device/xiaomi/sm8250-common

# Vendor Tree
git clone --depth=1 https://gitlab.com/pranavtalmale/android_vendor_xiaomi_munch.git -b meme-14 vendor/xiaomi/munch
# Vendor-Common Tree
git clone --depth=1 https://gitlab.com/pranavtalmale/android_vendor_xiaomi_sm8250-common.git -b meme-14 vendor/xiaomi/sm8250-common

# Nexus Kernel
git clone --depth=1 --single-branch https://github.com/Tokito-Kun/nexus_kernel_xiaomi_sm8250 -b rebase-new kernel/xiaomi/sm8250
echo "CONFIG_KSU=y" >> kernel/xiaomi/sm8250/arch/arm64/configs/munch_defconfig

BUILD_TIME=$(date -u +%Y%m%d-%H%M)
export SELINUX_IGNORE_NEVERALLOWS=true
. build/envsetup.sh && lunch voltage_munch-eng  && make -j$(nproc --all) target-files-package otatools
sign_target_files_apks -o -d keys out/target/product/munch/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip out/target/product/munch/signed-target-files.zip
ota_from_target_files -k keys/releasekey out/target/product/munch/signed-target-files.zip "out/target/product/munch/voltage-2.8-EOL-munch-$BUILD_TIME-UNOFFICIAL.zip"

#prebuilts/jdk/jdk17/linux-x86/bin/java -Xmx2048m -Djava.library.path="out/host/linux-x86/lib64" -jar out/host/linux-x86/framework/signapk.jar  keys/releasekey.x509.pem keys/releasekey.pk8 out/input.apk out/signed.apk
