$(call inherit-product, vendor/infinity/config/common.mk)
$(call inherit-product, vendor/infinity/config/common_mobile_full.mk)
$(call inherit-product, vendor/infinity/config/BoardConfigSoong.mk)
$(call inherit-product, vendor/infinity/config/BoardConfigInfinity.mk)
$(call inherit-product, device/lineage/sepolicy/common/sepolicy.mk)
-include vendor/infinity/build/core/config.mk
TARGET_NO_KERNEL_OVERRIDE := true
TARGET_NO_KERNEL_IMAGE := true
TARGET_SUPPORT_BLUR := true
SELINUX_IGNORE_NEVERALLOWS := true

 OTA
 PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.system.ota.json_url=https://raw.githubusercontent.com/rajansingh9745/infinity-x/15/ota.json

# Set Bootanimation at 1080P
TARGET_BOOT_ANIMATION_RES := 1080

# APN
PRODUCT_PACKAGES += apns-conf.xml

# Infinity Flags
INFINITY_MAINTAINER := "Rajan Singh"
TARGET_SUPPORTS_BLUR := true
WITH_GAPPS := true
TARGET_BUILD_GOOGLE_TELEPHONY := true
USE_MOTO_CALCULATOR := true
ro.infinity.soc=Mediatek Dimensity 8100 max
ro.infinity.battery=5080 mAh
ro.infinity.display=1080 x 2460, 144 Hz
ro.infinity.camera=64MP + 8MP + 2MP
