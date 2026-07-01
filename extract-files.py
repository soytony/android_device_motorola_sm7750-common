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
    'system_ext/etc/permissions/vendor.qti.hardware.c2pa-V1-java.xml': blob_fixup()
        .regex_replace(r'<\?xml version="2\.0"', r'<?xml version="1.0"'),
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
