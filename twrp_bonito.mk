# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

# Inherit device configuration
$(call inherit-product, device/google/bonito/aosp_bonito.mk)

-include device/google/bonito/device-lineage.mk

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := bonito
PRODUCT_NAME := twrp_bonito
PRODUCT_MODEL := Pixel 3a XL
PRODUCT_BRAND := Google
