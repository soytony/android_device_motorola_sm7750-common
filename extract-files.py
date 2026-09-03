#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/motorola/sm7750-common',
    'hardware/qcom-caf/sm8750',
    'hardware/qcom-caf/wlan',
    'hardware/motorola',
    'vendor/qcom/opensource/commonsys-intf/display',
    'vendor/qcom/opensource/commonsys/display',
    'vendor/qcom/opensource/dataservices',
    'vendor/qcom/opensource/display',
]

blob_fixups: blob_fixups_user_type = {
    # Android 16 host_init_verifier requires an explicit service user.
    'vendor/etc/init/hw/init.mmi.tcmd.rc': blob_fixup()
        .regex_replace(
            r'(service vendor\.tcmd /vendor/bin/mot_tcmd\n    class core\n)',
            r'\1    user root\n',
        ),
    'system_ext/etc/permissions/vendor.qti.hardware.c2pa-V1-java.xml': blob_fixup()
        .regex_replace(r'<\?xml version="2\.0"', r'<?xml version="1.0"'),
    # Load Lineage's Motorola sub-HAL for touchscreen-backed wake gestures.
    'vendor/etc/sensors/hals.conf': blob_fixup()
        .add_line_if_missing('sensors.moto_ext.so'),
    # The stock double-tap sub-HAL exclusively grabs the gesture input device,
    # preventing InputReader and sensors.moto_ext from receiving its events.
    'vendor/lib64/sensors.moto.so': blob_fixup().binary_regex_replace(
        rb'\x01\xb2\x88\x52\x22\x00\x80\x52\x81\x00\xa8\x72',
        rb'\x01\xb2\x88\x52\x02\x00\x80\x52\x81\x00\xa8\x72',
    ),
    # QCRIL database migrations default this to 1, which prevents MT SMS
    # indications from reaching Android. Keep the property unknown/default-off.
    (
        'vendor/lib64/libqcrilNr.so',
        'vendor/lib64/libril-db.so',
    ): blob_fixup().binary_regex_replace(
        rb'persist\.vendor\.radio\.poweron_opt',
        rb'persist.vendor.radio.poweron_ign',
    ),
}

module = ExtractUtilsModule(
    'sm7750-common',
    'motorola',
    blob_fixups=blob_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
