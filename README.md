# Motorola sm7750-common (SM7750)

Platform-common device tree for Motorola devices based on Qualcomm
Snapdragon 7 Gen 4 (SM7750), platform codename "sun".

Adapted from sm8550-common (kalama) structure.

## Structure

- `BoardConfigCommon.mk` -- platform board config
- `common.mk` -- platform common packages and configs
- `manifest.xml` -- vintf manifest
- `rootdir/etc/` -- fstab, init scripts
- `sepolicy/` -- platform SELinux rules
- `lineagehw/` -- LineageOS hardware HALs
- `overlay-lineage/` -- LineageOS RRO overlays
- `configs/` -- shared configs
- `wifi/` -- Wi-Fi configs
- `gps/` -- GPS configs
- `bluetooth/` -- Bluetooth configs
- `recovery/` -- recovery UI config
- `seccomp/` -- seccomp policy
- `audio/` -- shared audio configs
- `libinit/` -- platform-specific init helpers
