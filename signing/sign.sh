#!/usr/bin/bash

sign_target_files_apks -o -d keys \
    --extra_apks com.android.adbd.apex=keys/apex/com.android.adbd \
    --extra_apex_payload_key com.android.adbd.apex=keys/apex/com.android.adbd.pem \
    --extra_apks com.android.adservices.apex=keys/apex/com.android.adservices \
    --extra_apex_payload_key com.android.adservices.apex=keys/apex/com.android.adservices.pem \
    --extra_apks com.android.appsearch.apex=keys/apex/com.android.appsearch \
    --extra_apex_payload_key com.android.appsearch.apex=keys/apex/com.android.appsearch.pem \
    --extra_apks com.android.art.apex=keys/apex/com.android.art \
    --extra_apex_payload_key com.android.art.apex=keys/apex/com.android.art.pem \
    --extra_apks com.android.btservices.apex=keys/apex/com.android.btservices \
    --extra_apex_payload_key com.android.btservices.apex=keys/apex/com.android.btservices.pem \
    --extra_apks com.android.cellbroadcast.apex=keys/apex/com.android.cellbroadcast \
    --extra_apex_payload_key com.android.cellbroadcast.apex=keys/apex/com.android.cellbroadcast.pem \
    --extra_apks com.android.configinfrastructure.apex=keys/apex/com.android.configinfrastructure \
    --extra_apex_payload_key com.android.configinfrastructure.apex=keys/apex/com.android.configinfrastructure.pem \
    --extra_apks com.android.conscrypt.apex=keys/apex/com.android.conscrypt \
    --extra_apex_payload_key com.android.conscrypt.apex=keys/apex/com.android.conscrypt.pem \
    --extra_apks com.android.devicelock.apex=keys/apex/com.android.devicelock \
    --extra_apex_payload_key com.android.devicelock.apex=keys/apex/com.android.devicelock.pem \
    --extra_apks com.android.extservices.apex=keys/apex/com.android.extservices \
    --extra_apex_payload_key com.android.extservices.apex=keys/apex/com.android.extservices.pem \
    --extra_apks com.android.hardware.cas.apex=keys/apex/com.android.hardware.cas \
    --extra_apex_payload_key com.android.hardware.cas.apex=keys/apex/com.android.hardware.cas.pem \
    --extra_apks com.android.healthfitness.apex=keys/apex/com.android.healthfitness \
    --extra_apex_payload_key com.android.healthfitness.apex=keys/apex/com.android.healthfitness.pem \
    --extra_apks com.android.i18n.apex=keys/apex/com.android.i18n \
    --extra_apex_payload_key com.android.i18n.apex=keys/apex/com.android.i18n.pem \
    --extra_apks com.android.ipsec.apex=keys/apex/com.android.ipsec \
    --extra_apex_payload_key com.android.ipsec.apex=keys/apex/com.android.ipsec.pem \
    --extra_apks com.android.media.apex=keys/apex/com.android.media \
    --extra_apex_payload_key com.android.media.apex=keys/apex/com.android.media.pem \
    --extra_apks com.android.mediaprovider.apex=keys/apex/com.android.mediaprovider \
    --extra_apex_payload_key com.android.mediaprovider.apex=keys/apex/com.android.mediaprovider.pem \
    --extra_apks com.android.media.swcodec.apex=keys/apex/com.android.media.swcodec \
    --extra_apex_payload_key com.android.media.swcodec.apex=keys/apex/com.android.media.swcodec.pem \
    --extra_apks com.android.neuralnetworks.apex=keys/apex/com.android.neuralnetworks \
    --extra_apex_payload_key com.android.neuralnetworks.apex=keys/apex/com.android.neuralnetworks.pem \
    --extra_apks com.android.ondevicepersonalization.apex=keys/apex/com.android.ondevicepersonalization \
    --extra_apex_payload_key com.android.ondevicepersonalization.apex=keys/apex/com.android.ondevicepersonalization.pem \
    --extra_apks com.android.os.statsd.apex=keys/apex/com.android.os.statsd \
    --extra_apex_payload_key com.android.os.statsd.apex=keys/apex/com.android.os.statsd.pem \
    --extra_apks com.android.permission.apex=keys/apex/com.android.permission \
    --extra_apex_payload_key com.android.permission.apex=keys/apex/com.android.permission.pem \
    --extra_apks com.android.resolv.apex=keys/apex/com.android.resolv \
    --extra_apex_payload_key com.android.resolv.apex=keys/apex/com.android.resolv.pem \
    --extra_apks com.android.rkpd.apex=keys/apex/com.android.rkpd \
    --extra_apex_payload_key com.android.rkpd.apex=keys/apex/com.android.rkpd.pem \
    --extra_apks com.android.runtime.apex=keys/apex/com.android.runtime \
    --extra_apex_payload_key com.android.runtime.apex=keys/apex/com.android.runtime.pem \
    --extra_apks com.android.scheduling.apex=keys/apex/com.android.scheduling \
    --extra_apex_payload_key com.android.scheduling.apex=keys/apex/com.android.scheduling.pem \
    --extra_apks com.android.sdkext.apex=keys/apex/com.android.sdkext \
    --extra_apex_payload_key com.android.sdkext.apex=keys/apex/com.android.sdkext.pem \
    --extra_apks com.android.tethering.apex=keys/apex/com.android.tethering \
    --extra_apex_payload_key com.android.tethering.apex=keys/apex/com.android.tethering.pem \
    --extra_apks com.android.tzdata.apex=keys/apex/com.android.tzdata \
    --extra_apex_payload_key com.android.tzdata.apex=keys/apex/com.android.tzdata.pem \
    --extra_apks com.android.uwb.apex=keys/apex/com.android.uwb \
    --extra_apex_payload_key com.android.uwb.apex=keys/apex/com.android.uwb.pem \
    --extra_apks com.android.virt.apex=keys/apex/com.android.virt \
    --extra_apex_payload_key com.android.virt.apex=keys/apex/com.android.virt.pem \
    --extra_apks com.android.vndk.v30.apex=keys/apex/com.android.vndk.v30 \
    --extra_apex_payload_key com.android.vndk.v30.apex=keys/apex/com.android.vndk.v30.pem \
    --extra_apks com.android.vndk.v31.apex=keys/apex/com.android.vndk.v31 \
    --extra_apex_payload_key com.android.vndk.v31.apex=keys/apex/com.android.vndk.v31.pem \
    --extra_apks com.android.vndk.v32.apex=keys/apex/com.android.vndk.v32 \
    --extra_apex_payload_key com.android.vndk.v32.apex=keys/apex/com.android.vndk.v32.pem \
    --extra_apks com.android.vndk.v33.apex=keys/apex/com.android.vndk.v33 \
    --extra_apex_payload_key com.android.vndk.v33.apex=keys/apex/com.android.vndk.v33.pem \
    --extra_apks com.android.wifi.apex=keys/apex/com.android.wifi \
    --extra_apex_payload_key com.android.wifi.apex=keys/apex/com.android.wifi.pem \
    out/target/product/munch/obj/PACKAGING/target_files_intermediates/*-target_files.zip \
    out/target/product/munch/signed-target-files.zip 2>&1 | tee out/target/product/munch/signing.log

BUILD_PROP="$ANDROID_BUILD_TOP/out/target/product/munch/obj/PACKAGING/target_files_intermediates/voltage_munch-target_files/SYSTEM/build.prop"
BUILD_VERSION=$(grep org.voltage.version $BUILD_PROP | cut -d "=" -f 2)
DEVICE=$(grep ro.voltage.device $BUILD_PROP | cut -d "=" -f 2 | head -n 1)
BUILD_DATE=$(grep ro.build.date.utc $BUILD_PROP | cut -d "=" -f 2 | xargs -I {} date -d @{} -u +"%Y%m%d-%H%M")
BUILD_STATUS=$(grep ro.voltage.build.status $BUILD_PROP | cut -d "=" -f 2)
BUILD_TYPE=$(grep ro.build.type $BUILD_PROP | cut -d "=" -f 2)
ZIPNAME="voltage-$BUILD_VERSION-$DEVICE-$BUILD_DATE-$BUILD_STATUS"

ota_from_target_files -k keys/releasekey out/target/product/munch/obj/PACKAGING/target_files_intermediates/voltage_munch-target_files.zip "out/target/product/munch/$ZIPNAME.zip"

echo "New Build: out/target/product/munch/$ZIPNAME.zip"
