#!/usr/bin/bash

set -e

err() {
    echo -e " \e[91m[+]\e[39m $*"
    exit 1
}

pif_signer() {
    [[ -z "$ANDROID_BUILD_TOP" ]] && err "Run lunch"
    pif_dir="$ANDROID_BUILD_TOP/vendor/certification/PifPrebuilt"

    cd $pif_dir || err "certification Repo not found"

    commit_head=$(git log --oneline -1 | awk -F ' ' '{ print $1 }')
    commit_date=$(git show $commit_head | grep -e Date: | awk -F '  ' '{ print $2 }' | cut -f1 -d '+' | date -d - +"%d/%m/%Y")
    commit_msg=$(git log --oneline -1)

    # Sign
    cd "$ANDROID_BUILD_TOP"
    if [[ -f $ANDROID_BUILD_TOP/out/target/product/munch/signedPif.apk ]];then
    	echo "Found an existing signedPif Package | Removing it..."
	rm -v $ANDROID_BUILD_TOP/out/target/product/munch/signedPif.apk
    fi
    prebuilts/jdk/jdk17/linux-x86/bin/java -Xmx2048m -Djava.library.path="out/host/linux-x86/lib64" -jar out/host/linux-x86/framework/signapk.jar \
    keys/platform.x509.pem keys/platform.pk8 \
    $pif_dir/PifPrebuilt.apk out/target/product/munch/signedPif.apk

    # upload
    source ~/.pip/bin/activate
    uploadgram @Tokitobuilds_to $ANDROID_BUILD_TOP/out/target/product/munch/signedPif.apk \
    --progress --t voltage.png \
    --caption "VoltageOS 3.4 Play Intergrity Fix
Build Date: $commit_date"
}

pif_signer
