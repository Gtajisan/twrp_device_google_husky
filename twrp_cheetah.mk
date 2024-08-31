#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from generic device
$(call inherit-product, device/google/cheetah/device.mk)

PRODUCT_DEVICE := cheetah
PRODUCT_NAME := twrp_cheetah
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 7 Pro
PRODUCT_MANUFACTURER := google

PRODUCT_GMS_CLIENTID_BASE := android-google

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="cheetah-user 14 AP2A.240805.005 12025142 release-keys"

BUILD_FINGERPRINT := google/cheetah/cheetah:14/AP2A.240805.005/12025142:user/release-keys
