#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#
LOCAL_PATH := device/google/husky
DEVICE_PATH := device/google/husky

TARGET_BOARD_KERNEL_HEADERS := device/google/shusky-kernel/kernel-headers

# Inherit from common AOSP config
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# Inherit from virtual AB OTA config
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

$(call inherit-product-if-exists, vendor/google_devices/husky/prebuilts/device-vendor-husky.mk)
$(call inherit-product-if-exists, vendor/google_devices/zuma/prebuilts/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/zuma/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/husky/proprietary/husky/device-vendor-husky.mk)
$(call inherit-product-if-exists, vendor/google_devices/husky/proprietary/husky-vendor.mk)

#include device/google/shusky-sepolicy/husky-sepolicy.mk
#include device/google/zuma-sepolicy/zuma-sepolicy.mk
include hardware/google/pixel/vibrator/cs40l26/device.mk
include device/google/gs-common/bcmbt/bluetooth.mk
include device/google/gs-common/touch/stm/stm20.mk
include device/google/gs-common/touch/gti/gti.mk
include device/google/gs-common/touch/touchinspector/touchinspector.mk

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/fstab.zuma:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/system/etc/fstab.zuma

PRODUCT_PACKAGES += \
    linker.vendor_ramdisk \
    resize2fs.vendor_ramdisk \
    fsck.vendor_ramdisk \
    tune2fs.vendor_ramdisk

# Init files
PRODUCT_COPY_FILES += \
device/google/husky/init.husky.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.husky.rc

# Init files
PRODUCT_COPY_FILES += \
	device/google/husky/recovery/root/init.recovery.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.recovery.usb.rc \
	device/google/husky/recovery/root/vendor/etc/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

# Device Manifest file
DEVICE_MANIFEST_FILE := \
device/google/husky/manifest.xml

#SHIPPING API
PRODUCT_SHIPPING_API_LEVEL := 32
PRODUCT_TARGET_VNDK_VERSION := 32

# define hardware platform
PRODUCT_PLATFORM := zuma

# A/B OTA
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    checkpoint_gc \
    update_engine \
    update_engine_sideload \
    update_verifier

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service

PRODUCT_PACKAGES += \
    bootctrl.zuma \
    bootctrl.zuma.recovery

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    android.hardware.fastboot@1.0-impl-mock.recovery \
    fastbootd 

# vndservicemanager and vndservice no longer included in API 30+, however needed by vendor code.
PRODUCT_PACKAGES += vndservicemanager
PRODUCT_PACKAGES += vndservice

# Hidl Service
PRODUCT_ENFORCE_VINTF_MANIFEST := true
PRODUCT_PACKAGES += \
    libhidltransport.vendor \
    libhwbinder.vendor

# Display Config
PRODUCT_COPY_FILES += \
        device/google/husky/display_colordata_dev_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_colordata_dev_cal0.pb \
        device/google/husky/display_golden_google-hk3_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_golden_google-hk3_cal0.pb \
        device/google/husky/display_golden_external_display_cal2.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_golden_external_display_cal2.pb

# Display
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.lbe.supported=1
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.set_idle_timer_ms=1500
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.ignore_hdr_camera_layers=true

# config of display brightness dimming
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.0.brightness.dimming.usage?=1
PRODUCT_VENDOR_PROPERTIES += \
    vendor.primarydisplay.op.hs_hz=120 \
    vendor.primarydisplay.op.ns_hz=60 \
    vendor.primarydisplay.op.ns_min_dbv=1172

# kernel idle timer for display driver
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.support_kernel_idle_timer=true

# lhbm peak brightness delay: decided by kernel
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.primarydisplay.lhbm.frames_to_reach_peak_brightness=0

# Display LBE
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.lbe.supported=1

# blocking zone for min idle refresh rate
PRODUCT_VENDOR_PROPERTIES += \
    vendor.primarydisplay.min_idle_refresh_rate.default=1 \
    vendor.primarydisplay.min_idle_refresh_rate.blocking_zone=10 \
    vendor.primarydisplay.min_idle_refresh_rate.blocking_zone_dbv=492

# Display ACL
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.0.brightness.acl.default=0

# display color data
PRODUCT_COPY_FILES += \
	device/google/husky/panel_config_google-hk3_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/panel_config_google-hk3_cal0.pb

# Touch
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# USB HAL
PRODUCT_PACKAGES += \
	android.hardware.usb-service
PRODUCT_PACKAGES += \
	android.hardware.usb.gadget-service

# SecureElement
PRODUCT_PACKAGES += \
	android.hardware.secure_element@1.2-service-gto \
	android.hardware.secure_element@1.2-service-gto-ese2

# Vibrator HAL
ACTUATOR_MODEL := luxshare_ict_081545
ADAPTIVE_HAPTICS_FEATURE := adaptive_haptics_v1
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.vibrator.hal.chirp.enabled=0 \
    ro.vendor.vibrator.hal.device.mass=0.222 \
    ro.vendor.vibrator.hal.loc.coeff=2.8 \
    persist.vendor.vibrator.hal.context.enable=false \
    persist.vendor.vibrator.hal.context.scale=60 \
    persist.vendor.vibrator.hal.context.fade=true \
    persist.vendor.vibrator.hal.context.cooldowntime=1600 \
    persist.vendor.vibrator.hal.context.settlingtime=5000 \
    ro.vendor.vibrator.hal.dbc.enable=true \
    ro.vendor.vibrator.hal.dbc.envrelcoef=8353728 \
    ro.vendor.vibrator.hal.dbc.riseheadroom=1909602 \
    ro.vendor.vibrator.hal.dbc.fallheadroom=1909602 \
    ro.vendor.vibrator.hal.dbc.txlvlthreshfs=2516583 \
    ro.vendor.vibrator.hal.dbc.txlvlholdoffms=0 \
    ro.vendor.vibrator.hal.pm.activetimeout=5

# Power HAL config
PRODUCT_COPY_FILES += \
	device/google/husky/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# PowerStats HAL
PRODUCT_SOONG_NAMESPACES += \
    device/google/husky/powerstats \
    device/google/husky

# Identity credential
PRODUCT_PACKAGES += \
    android.hardware.identity-support-lib.vendor:64 \
    android.hardware.identity_credential.xml

# Nos
PRODUCT_PACKAGES += \
    libkeymaster4support.vendor:64 \
    libkeymint_support.vendor:64 \
    libnos:64 \
    libnosprotos:64 \
    libnos_client_citadel:64 \
    libnos_datagram:64 \
    libnos_datagram_citadel:64 \
    libnos_transport:64 \
    nos_app_avb:64 \
    nos_app_identity:64 \
    nos_app_keymaster:64 \
    nos_app_weaver:64 \
    pixelpowerstats_provider_aidl_interface-cpp.vendor:64

# Misc interfaces
PRODUCT_PACKAGES += \
    android.frameworks.stats-V1-ndk.vendor:32 \
    android.hardware.authsecret@1.0.vendor:64 \
    android.hardware.biometrics.common-V2-ndk.vendor:64 \
    android.hardware.biometrics.face-V2-ndk.vendor:64 \
    android.hardware.biometrics.face@1.0.vendor:64 \
    android.hardware.biometrics.fingerprint-V2-ndk.vendor:64 \
    android.hardware.input.common-V1-ndk.vendor:64 \
    android.hardware.input.processor-V1-ndk.vendor:64 \
    android.hardware.keymaster@3.0.vendor:64 \
    android.hardware.keymaster@4.0.vendor:64 \
    android.hardware.keymaster@4.1.vendor:64 \
    android.hardware.neuralnetworks-V4-ndk.vendor:64 \
    android.hardware.oemlock@1.0.vendor:64 \
    android.hardware.power@1.0.vendor:64 \
    android.hardware.power@1.1.vendor:64 \
    android.hardware.power@1.2.vendor:64 \
    android.hardware.radio.config@1.0.vendor \
    android.hardware.radio.config@1.1.vendor \
    android.hardware.radio.config@1.2.vendor \
    android.hardware.radio.deprecated@1.0.vendor \
    android.hardware.radio@1.2.vendor \
    android.hardware.radio@1.3.vendor \
    android.hardware.radio@1.4.vendor \
    android.hardware.radio@1.5.vendor \
    android.hardware.radio@1.6.vendor \
    android.hardware.secure_element@1.0.vendor:32 \
    android.hardware.secure_element@1.1.vendor:32 \
    android.hardware.secure_element@1.2.vendor:32 \
    android.hardware.thermal@1.0.vendor:32 \
    android.hardware.thermal@2.0.vendor:32 \
    android.hardware.weaver@1.0.vendor:64 \
    android.hardware.wifi@1.1.vendor:64 \
    android.hardware.wifi@1.2.vendor:64 \
    android.hardware.wifi@1.3.vendor:64 \
    android.hardware.wifi@1.4.vendor:64 \
    android.hardware.wifi@1.5.vendor:64 \
    android.hardware.wifi@1.6.vendor:64 \
    com.google.hardware.pixel.display-V4-ndk.vendor:64 \
    com.google.hardware.pixel.display-V5-ndk.vendor \
    com.google.hardware.pixel.display-V6-ndk.vendor

# Shell scripts
PRODUCT_COPY_FILES += \
	device/google/zuma/disable_contaminant_detection.sh:$(TARGET_COPY_OUT_VENDOR)/bin/hw/disable_contaminant_detection.sh

# PowerStats HAL
PRODUCT_PACKAGES += \
	android.hardware.power.stats-service.pixel

PRODUCT_PACKAGES += \
	android.hardware.graphics.mapper@4.0-impl \
	android.hardware.graphics.allocator-V1-service

PRODUCT_PROPERTY_OVERRIDES += \
	debug.sf.disable_backpressure=0 \
	debug.sf.enable_gl_backpressure=1 \
	debug.sf.enable_sdr_dimming=1 \
	debug.sf.dim_in_gamma_in_enhanced_screenshots=1


PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.use_phase_offsets_as_durations=1
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.late.sf.duration=10500000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.late.app.duration=16600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.early.sf.duration=16600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.early.app.duration=16600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.earlyGl.sf.duration=16600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.earlyGl.app.duration=16600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.frame_rate_multiple_threshold=120
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.layer_caching_active_layer_timeout_ms=1000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.treat_170m_as_sRGB=1

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.enable_layer_caching=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.set_idle_timer_ms?=80
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.set_touch_timer_ms=200
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.set_display_power_timer_ms=1000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.use_content_detection_for_refresh_rate=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.max_frame_buffer_acquired_buffers=3

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.supports_background_blur=1

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.has_wide_color_display=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.has_HDR_display=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.use_color_management=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.protected_contents=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.display_update_imminent_timeout_ms=50

# The data space of wide color gamut composition preference is Dataspace::DISPLAY_P3
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.wcg_composition_dataspace=143261696

PRODUCT_PROPERTY_OVERRIDES += \
	persist.sys.sf.native_mode=2

$(call soong_config_set,google_displaycolor,displaycolor_platform,zuma)
PRODUCT_PACKAGES += \
	android.hardware.composer.hwc3-service.pixel \
	libdisplaycolor \
	displaycolor_service

# Use FUSE passthrough
PRODUCT_PRODUCT_PROPERTIES += \
	persist.sys.fuse.passthrough.enable=true

# Touch service
include device/google/gs-common/touch/twoshay/aidl_zuma.mk

# Build libion
PRODUCT_PACKAGES += \
    libion

# Device resolution
TARGET_SCREEN_WIDTH := 1344
TARGET_SCREEN_HEIGHT := 2992
