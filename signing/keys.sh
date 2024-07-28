#!/usr/bin/bash

# Fetch Latest Make_key Scripts From AOSP Source
curl "https://android.googlesource.com/platform/development/+/refs/heads/main/tools/make_key?format=text" | base64 -d > make_key
sed -i 's|2048|4096|g' make_key
chmod +x make_key

# Variables Required for Keygen
subject='/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN=Android/emailAddress=android@android.com'

for x in releasekey platform shared media networkstack testkey verity sdk_sandbox bluetooth; do
    ./make_key ./$x "$subject";
done

for apex in $(cat apex/apex.list); do
    ./make_key ./apex/$apex "$subject";
    openssl pkcs8 -in ./apex/$apex.pk8 -inform DER -nocrypt -out ./apex/$apex.pem;
done

## TO-DO make sign.sh auto-genrated
apex-sign() {
    for apex in $(cat apex/apex.list); do
      echo "--extra_apks $apex.apex=apex/$apex \\"
      echo "--extra_apex_payload_key $apex.apex=apex/$apex.pem \\"
    done
}

if [[ "$1" == apex ]]; then
    apex-sign
fi
