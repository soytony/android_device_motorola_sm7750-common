#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
    echo "usage: $0 STOCK_APK OUTPUT_APK" >&2
    exit 2
fi

stock_apk=$1
output_apk=$2
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

apktool d -f "$stock_apk" -o "$work_dir/cqatest"
custom_interface="$work_dir/cqatest/smali_classes2/com/motorola/motocit/fingerprint/CustomInterface.smali"

# Lineage has no Motorola framework resource at the stock package-0x01 ID.
sed -i '/^\.method public static getLocalHbmRefreshRate/,/^\.end method/c\
.method public static getLocalHbmRefreshRate(Landroid/content/Context;)F\
    .locals 0\
    .param p0, "context"    # Landroid/content/Context;\
\
    const/4 p0, 0x0\
\
    return p0\
.end method' "$custom_interface"

# The Motorola setting is an optional display hint; failure must not abort CQATest.
sed -i '/new-instance v1, Ljava\/lang\/RuntimeException;/,/throw v1/c\
    return-void' "$custom_interface"
apktool b "$work_dir/cqatest" -o "$output_apk"

echo "Built unsigned CQATest APK: $output_apk"
echo "The Android build must sign it with certificate: \"platform\"."
