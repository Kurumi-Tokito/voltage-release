#!/bin/bash

set -e

GITPASS="" # Git Token
CC_DIR="$(pwd -P)/../.ccache" # CCache Path

if [ $(command -v apt) ]; then
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install git-core git-lfs jq rsync python3 gnupg ccache flex bison build-essential zip curl zlib1g-dev libssl-dev libc6-dev-i386 libncurses5 x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig -y
    sudo ln -s /usr/bin/python3 /usr/bin/python
elif [ $(command -v pacman) ]; then
    sudo pacman -Sy --needed --noconfirm -< arch-pkg
fi

if [ ! $(command -v repo) ]; then
    if [ $(command -v pacman) ]; then
        sudo pacman -S repo
    fi
elif [ -f ~/.bin/repo ]; then
    export PATH="${HOME}/.bin:${PATH}"
else
    mkdir -p ~/.bin
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
    chmod a+rx ~/.bin/repo
    export PATH="${HOME}/.bin:${PATH}"
fi

# Git Config
if [ ! -f "$(realpath ~/.gitconfig)" ]; then
    git config --global user.email "93600306+Ivy-Tokito@users.noreply.github.com"
    git config --global user.name "Ivy-Tokito"
fi

# Repo Clone
mkdir voltageos && cd voltageos
yes | repo init -u https://github.com/VoltageOS/manifest.git -b 14 --git-lfs
git clone https://github.com/Ivy-Tokito/munch_manifest -b voltage-14 .repo/local_manifests
git clone https://$GITPASS@github.com/Ivy-Tokito/Private_keys.git keys
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# Build
export BUILD_USERNAME=Tokito
export USE_CCACHE=1 CCACHE_EXEC=$(which ccache)
[[ ! -z "$CC_DIR" ]] && export CCACHE_DIR="$CC_DIR"
ccache -M 20G

sudo mount -o remount,size=32G /tmp #increase /tmp space to 32G #to avoid no space in /tmp error

. build/envsetup.sh && lunch voltage_munch-ap1a-user && make -j$(nproc --all) target-files-package otatools

local BUILD_PROP="$ANDROID_BUILD_TOP/out/target/product/munch/obj/PACKAGING/target_files_intermediates/voltage_munch-target_files/SYSTEM/build.prop"
local BUILD_VERSION=$(grep org.voltage.version $BUILD_PROP | cut -d "=" -f 2)
local DEVICE=$(grep ro.voltage.device $BUILD_PROP | cut -d "=" -f 2 | head -n 1)
local BUILD_DATE=$(grep ro.build.date.utc $BUILD_PROP | cut -d "=" -f 2 | xargs -I {} date -d @{} -u +"%Y%m%d-%H%M")
local BUILD_STATUS=$(grep ro.voltage.build.status $BUILD_PROP | cut -d "=" -f 2)
local BUILD_TYPE=$(grep ro.build.type $BUILD_PROP | cut -d "=" -f 2)
ZIPNAME="voltage-$BUILD_VERSION-$DEVICE-$BUILD_DATE-$BUILD_STATUS"

sign_target_files_apks -o -d keys --extra_apks PifPrebuilt.apk=keys/platform \
out/target/product/munch/obj/PACKAGING/target_files_intermediates/*-target_files.zip out/target/product/munch/$BUILD_DATE-signed-target-files.zip
check_target_files_vintf -v out/target/product/munch/$BUILD_DATE-signed-target-files.zip 2>&1 | tee out/target/product/munch/vintf.log
ota_from_target_files -k keys/releasekey out/target/product/munch/signed-target-files.zip "out/target/product/munch/$ZIPNAME.zip"

# Delta
#[[ -z "$OLD_BUILD_DATE" ]] && err "Old Build Date Not Found For Delta Build"
#[[ -f "out/target/product/munch/$OLD_BUILD_DATE-signed-target-files.zip" ]] || err "Old Signed Target-Files Not Found"
#ota_from_target_files -k keys/releasekey -i out/target/product/munch/$OLD_BUILD_DATE-signed-target-files.zip out/target/product/munch/$BUILD_DATE-signed-target-files.zip "out/target/product/munch/$ZIPNAME-Delta.zip"

#ota_from_target_files -k build/target/product/security/testkey out/target/product/munch/obj/PACKAGING/target_files_intermediates/*-target_files.zip out/target/product/munch/unsigned-test-ota-package.zip
#img_from_target_files out/target/product/munch/signed-target-files.zip "out/target/product/munch/voltage-3.2-munch-$BUILD_TIME-UNOFFICIAL-Fastboot.zip"
#. build/envsetup.sh && brunch voltage_munch-ap1a-eng -j$(nproc --all)
#prebuilts/jdk/jdk17/linux-x86/bin/java -Xmx2048m -Djava.library.path="out/host/linux-x86/lib64" -jar out/host/linux-x86/framework/signapk.jar  keys/releasekey.x509.pem keys/releasekey.pk8 out/input.apk out/signed.apk
