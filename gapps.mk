GAPPS_VARIANT := nano
GAPPS_FORCE_PACKAGE_OVERRIDES := true
PRODUCT_PACKAGES += \
       Chrome \
       CalculatorGoogle \
       PrebuiltDeskClockGoogle \
       CalendarGooglePrebuilt \
       GoogleHome \
       LatinImeGoogle \
       phh-overrides

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
