# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

# Inherit device configuration
$(call inherit-product, device/google/bonito/aosp_sargo.mk)

-include device/google/bonito/device-lineage.mk

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := sargo
PRODUCT_NAME := twrp_sargo
PRODUCT_MODEL := Pixel 3a
PRODUCT_BRAND := Google

$(call inherit-product, vendor/google/sargo/sargo-vendor.mk)
