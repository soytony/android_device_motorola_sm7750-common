#!/system/bin/sh

set -u

MODULE_DIR=/lib/modules
TAG=recovery-touch

log()
{
    echo "$TAG: $*" > /dev/kmsg
}

load_module()
{
    local module="$1"
    local path="$MODULE_DIR/$module"

    if [ ! -f "$path" ]; then
        log "missing $module"
        return 1
    fi

    if grep -qw "${module%.ko}" /proc/modules; then
        log "already loaded $module"
        return 0
    fi

    log "insmod $module"
    if insmod "$path"; then
        log "loaded $module"
        return 0
    fi

    log "failed $module"
    return 1
}

log "waiting for recovery UI before loading touch modules"
sleep 4

load_module smmu_proxy_dlkm.ko || exit 1
load_module hdcp_qseecom_dlkm.ko || exit 1
load_module sensors_class.ko || exit 1
load_module mmi_relay.ko || exit 1
load_module touchscreen_mmi.ko || exit 1
load_module mmi_annotate.ko || exit 1
load_module mmi_info.ko || exit 1
load_module goodix_brl_mmi.ko || exit 1

log "touch module chain completed"
