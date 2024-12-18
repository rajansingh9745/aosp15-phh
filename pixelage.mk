$(call inherit-product, vendor/pixelage/config/common_full_phone.mk)
$(call inherit-product, vendor/pixelage/config/common.mk)
$(call inherit-product, vendor/pixelage/config/BoardConfigPixelage.mk)
$(call inherit-product, vendor/pixelage/config/BoardConfigSoong.mk)
$(call inherit-product, device/pixelage/sepolicy/common/sepolicy.mk)
-include vendor/pixelage/build/core/config.mk

SELINUX_IGNORE_NEVERALLOWS := true
TARGET_NO_KERNEL_OVERRIDE := true
TARGET_NO_KERNEL_IMAGE := true
TARGET_USES_PREBUILT_VENDOR_SEPOLICY := true
TARGET_HAS_FUSEBLK_SEPOLICY_ON_VENDOR := true

TARGET_BOOT_ANIMATION_RES := 1080

TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_NOT_USES_BLUR := true
EXTRA_UDFPS_ANIMATIONS := true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.system.ota.json_url=https://raw.githubusercontent.com/rajansingh9745/treble_pixelageFest_GSI/14/ota.json
