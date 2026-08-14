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

## USB

USB device mode uses the legacy configfs path with FunctionFS MTP. Keep
`android.hardware.usb.gadget-service.qti` out of `PRODUCT_PACKAGES`: it
conflicts with the legacy property-driven setup and prevents MTP from pulling
down and reconfiguring the gadget. `android.hardware.usb-service.qti` remains
enabled for USB port and role management.

The USB-C port supports dual-role operation, including source/host mode for
USB OTG and sink/device mode for MTP and ADB.
