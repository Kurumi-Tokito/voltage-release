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
repo init -u https://github.com/VoltageOS/manifest.git -b 14 --git-lfs
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
git clone https://$GITPASS@github.com/Tokito-Kun/Private_keys.git keys

# Smart 5G patch
rm -r frameworks/base
git clone --depth=1 https://github.com/Yukimitsu-Tokito/voltage_frameworks_base.git -b 14-patch frameworks/base

rm -r packages/apps/Settings
git clone --depth=1 https://github.com/Yukimitsu-Tokito/voltage_packages_apps_Settings.git -b 14-patch packages/apps/Settings

# NTFS-3G
git clone https://github.com/LineageOS/android_external_ntfs-3g.git external/ntfs-3g

# KProfiles
git clone https://github.com/KProfiles/android_packages_apps_Kprofiles packages/apps/KProfiles

# Prebuilt apps
git clone --depth=1 https://github.com/Tokito-Kun/android_packages_apps_Prebuilts.git -b 13 packages/apps/Prebuilts

# GrapheneOS Apps
git clone --depth=1 https://github.com/GrapheneOS/platform_external_Apps.git -b 14 external/Apps

# Device Tree
git clone --depth=1 https://github.com/Yukimitsu-Tokito/android_device_xiaomi_munch.git -b voltage-14 device/xiaomi/munch
# Device-Common Tree
git clone --depth=1 https://github.com/Yukimitsu-Tokito/android_device_xiaomi_sm8250-common.git -b voltage-14 device/xiaomi/sm8250-common

# Vendor Tree
git clone --depth=1 https://gitlab.com/Yukimitsu-Tokito/android_vendor_xiaomi_munch.git -b voltage-14 vendor/xiaomi/munch
# Vendor-Common Tree
git clone --depth=1 https://gitlab.com/Yukimitsu-Tokito/android_vendor_xiaomi_sm8250-common.git -b voltage-14 vendor/xiaomi/sm8250-common

# Nexus Kernel
git clone --depth=1 https://github.com/Yukimitsu-Tokito/nexus_kernel_xiaomi_sm8250 -b sched-4 kernel/xiaomi/sm8250
echo "CONFIG_KSU=y" >> kernel/xiaomi/sm8250/arch/arm64/configs/munch_defconfig

brunch voltage_munch-user -j$(nproc --all)

#export BUILD_TIME=$(date -u +%Y%m%d-%H%M)
#. build/envsetup.sh && lunch voltage_munch-user  && make -j$(nproc --all) target-files-package otatools img_from_target_files
#mount -o remount,size=20G /tmp #increase /tmp space to 20G #to avoid no space in /tmp error
#sign_target_files_apks -o -d keys out/target/product/munch/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip out/target/product/munch/signed-target-files.zip
#ota_from_target_files -k keys/releasekey out/target/product/munch/signed-target-files.zip "out/target/product/munch/voltage-3.2-munch-$BUILD_TIME-UNOFFICIAL.zip"
#img_from_target_files out/target/product/munch/signed-target-files.zip "out/target/product/munch/voltage-3.2-munch-$BUILD_TIME-UNOFFICIAL-Fastboot.zip"

#prebuilts/jdk/jdk17/linux-x86/bin/java -Xmx2048m -Djava.library.path="out/host/linux-x86/lib64" -jar out/host/linux-x86/framework/signapk.jar  keys/releasekey.x509.pem keys/releasekey.pk8 out/input.apk out/signed.apk
