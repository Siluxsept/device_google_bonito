#
# Copyright (C) 2017 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_USERIMAGES_USE_F2FS := true

LOCAL_PATH := device/google/bonito

# define hardware platform
PRODUCT_PLATFORM := sdm670

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

include device/google/bonito/device-audio-mfg.mk
include device/google/bonito/device.mk

# Bug 77867216
PRODUCT_PROPERTY_OVERRIDES += audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += vendor.audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += audio_hal.period_multiplier=2
PRODUCT_PROPERTY_OVERRIDES += af.fast_track_multiplier=1

# Set c2 codec in default
PRODUCT_PROPERTY_OVERRIDES += debug.stagefright.ccodec=4
PRODUCT_PROPERTY_OVERRIDES += debug.stagefright.omx_default_rank=512

# Setting vendor SPL
VENDOR_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)

# Set boot SPL
BOOT_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Audio low latency feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml

# Pro audio feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml

# Enable AAudio MMAP/NOIRQ data path.
# 1 is AAUDIO_POLICY_NEVER  means only use Legacy path.
# 2 is AAUDIO_POLICY_AUTO   means try MMAP then fallback to Legacy path.
# 3 is AAUDIO_POLICY_ALWAYS means only use MMAP path.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_policy=2
# 1 is AAUDIO_POLICY_NEVER  means only use SHARED mode
# 2 is AAUDIO_POLICY_AUTO   means try EXCLUSIVE then fallback to SHARED mode.
# 3 is AAUDIO_POLICY_ALWAYS means only use EXCLUSIVE mode.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_exclusive_policy=2

# Increase the apparent size of a hardware burst from 1 msec to 2 msec.
# A "burst" is the number of frames processed at one time.
# That is an increase from 48 to 96 frames at 48000 Hz.
# The DSP will still be bursting at 48 frames but AAudio will think the burst is 96 frames.
# A low number, like 48, might increase power consumption or stress the system.
PRODUCT_PROPERTY_OVERRIDES += aaudio.hw_burst_min_usec=2000

# Set lmkd options
PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.low_ram = false \
    ro.lmk.log_stats = true \

# A2DP offload enabled for compilation
AUDIO_FEATURE_ENABLED_A2DP_OFFLOAD := true

# A2DP offload supported
PRODUCT_PROPERTY_OVERRIDES += \
ro.bluetooth.a2dp_offload.supported=true

# A2DP offload disabled (UI toggle property)
PRODUCT_PROPERTY_OVERRIDES += \
persist.bluetooth.a2dp_offload.disabled=false

# A2DP offload DSP supported encoder list
PRODUCT_PROPERTY_OVERRIDES += \
persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac

# Modem loging file
PRODUCT_COPY_FILES += \
    device/google/bonito/init.logging.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(PRODUCT_PLATFORM).logging.rc

# Dumpstate HAL
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.0-service.bonito

# Enable retrofit dynamic partitions for all bonito
# and sargo targets
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_RETROFIT_DYNAMIC_PARTITIONS := true
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl.recovery \
    bootctrl.sdm710 \
    bootctrl.sdm710.recovery \
    check_dynamic_partitions \

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_product=true \
    POSTINSTALL_PATH_product=bin/check_dynamic_partitions \
    FILESYSTEM_TYPE_product=ext4 \
    POSTINSTALL_OPTIONAL_product=false \

#touch modules
PRODUCT_COPY_FILES += \
    device/google/bonito/prebuilts/ld.config.txt:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/ld.config.txt \
    device/google/bonito/modules/synaptics_dsx_core.ko:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/synaptics_dsx_core.ko \
    device/google/bonito/modules/synaptics_dsx_fw_update.ko:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/synaptics_dsx_fw_update.ko \
    device/google/bonito/modules/synaptics_dsx_rmi_dev.ko:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/synaptics_dsx_rmi_dev.ko \
    device/google/bonito/modules/synaptics_dsx_test_reporting.ko:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/synaptics_dsx_test_reporting.ko \
    device/google/bonito/touchdriver.sh:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/touchdriver.sh \
    device/google/bonito/prebuilts/qseecomd:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/qseecomd \
    device/google/bonito/prebuilts/libdrmfs.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libdrmfs.so \
    device/google/bonito/prebuilts/libxml2.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libxml2.so \
    device/google/bonito/prebuilts/libnetd_client.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libnetd_client.so \
    device/google/bonito/prebuilts/libspcom.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libspcom.so \
    device/google/bonito/prebuilts/libkeymasterdeviceutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libkeymasterdeviceutils.so \
    device/google/bonito/prebuilts/libgptutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libgptutils.so \
    device/google/bonito/prebuilts/libkeymasterutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libkeymasterutils.so \
    device/google/bonito/prebuilts/libqtikeymaster4.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libqtikeymaster4.so \
    device/google/bonito/prebuilts/libQSEEComAPI.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libQSEEComAPI.so \
    device/google/bonito/prebuilts/libdiag.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libdiag.so \
    device/google/bonito/prebuilts/libnos_client_citadel.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libnos_client_citadel.so \
    device/google/bonito/prebuilts/libnos_transport.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libnos_transport.so \
    device/google/bonito/prebuilts/citadeld:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/citadeld \
    device/google/bonito/prebuilts/prepdecrypt.sh:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/prepdecrypt.sh \
    device/google/bonito/prebuilts/time_daemon:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/time_daemon \
    device/google/bonito/prebuilts/libqmi_cci.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libqmi_cci.so \
    device/google/bonito/prebuilts/libqmi_common_so.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libqmi_common_so.so \
    device/google/bonito/prebuilts/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/manifest.xml \
    device/google/bonito/prebuilts/compatibility_matrix.device.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.device.xml \
    device/google/bonito/prebuilts/compatibility_matrix.legacy.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.legacy.xml \
    device/google/bonito/prebuilts/android.hardware.gatekeeper@1.0-service-qti:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.gatekeeper@1.0-service-qti \
    device/google/bonito/prebuilts/android.hardware.keymaster@4.0-service-qti:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.keymaster@4.0-service-qti \
    device/google/bonito/prebuilts/android.hardware.boot@1.0-service:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.boot@1.0-service \
    device/google/bonito/prebuilts/android.hardware.weaver@1.0-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.weaver@1.0-impl.nos.so \
    device/google/bonito/prebuilts/android.hardware.weaver@1.0-service.citadel:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.weaver@1.0-service.citadel \
    device/google/bonito/prebuilts/android.hardware.authsecret@1.0-service.citadel:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.authsecret@1.0-service.citadel \
    device/google/bonito/prebuilts/android.hardware.authsecret@1.0-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.authsecret@1.0-impl.nos.so \
    device/google/bonito/prebuilts/android.hardware.oemlock@1.0-service.citadel:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/android.hardware.oemlock@1.0-service.citadel \
    device/google/bonito/prebuilts/nos_app_weaver.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/nos_app_weaver.so \
    device/google/bonito/prebuilts/libnos_citadeld_proxy.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libnos_citadeld_proxy.so \
    device/google/bonito/prebuilts/libnos_datagram_citadel.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libnos_datagram_citadel.so\
    device/google/bonito/prebuilts/libprotobuf-cpp-full.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/libprotobuf-cpp-full.so \
    device/google/bonito/prebuilts/pixelpowerstats_provider_aidl_interface-cpp.so:$(TARGET_COPY_OUT_RECOVERY)/root/sbin/pixelpowerstats_provider_aidl_interface-cpp.so \
    device/google/bonito/prebuilts/twrp.flags:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/twrp.flags

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.use_color_management=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.protected_contents=true

PRODUCT_PACKAGES += \
    magiskboot_arm
# Set thermal warm reset
PRODUCT_PRODUCT_PROPERTIES += \
    ro.thermal_warmreset = true \
