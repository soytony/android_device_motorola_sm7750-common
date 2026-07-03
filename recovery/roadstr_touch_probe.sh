#!/system/bin/sh

set -u

MODULE_DIR=/lib/modules
TAG=roadstr-touch-probe

log()
{
    echo "$TAG: $*"
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
    dmesg | tail -80
    return 1
}

load_core()
{
    # Extra dependencies omitted from modules.load.recovery but required by
    # touchscreen_mmi.ko according to modules.dep.
    load_module smmu_proxy_dlkm.ko || return 1
    load_module hdcp_qseecom_dlkm.ko || return 1

    load_module sensors_class.ko || return 1
    load_module mmi_relay.ko || return 1
    load_module touchscreen_mmi.ko || return 1
}

case "${1:-all}" in
    core)
        load_core
        ;;
    goodix)
        load_core || exit 1
        load_module mmi_info.ko || exit 1
        load_module goodix_brl_mmi.ko
        ;;
    focaltech)
        load_core || exit 1
        load_module mmi_info.ko || exit 1
        load_module focaltech_v3_4.ko
        ;;
    all)
        load_core || exit 1
        load_module mmi_info.ko || exit 1
        load_module goodix_brl_mmi.ko || log "goodix load failed"
        load_module focaltech_v3_4.ko || log "focaltech load failed"
        ;;
    *)
        echo "usage: $0 [core|goodix|focaltech|all]" >&2
        exit 2
        ;;
esac

log "input devices:"
ls -l /dev/input 2>/dev/null || true
for name in /sys/class/input/input*/name; do
    [ -f "$name" ] || continue
    echo "$name: $(cat "$name")"
done

log "touch class:"
ls -l /sys/class/touchscreen 2>/dev/null || true
