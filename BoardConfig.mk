#
# Copyright (C) 2011 The Android Open-Source Project
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

TARGET_BOARD_OMAP_CPU := 4460
COMMON_FOLDER := device/samsung/tuna

# TI Enhancement Settings (Part 1)
#OMAP_ENHANCEMENT := true
#OMAP_ENHANCEMENT_BURST_CAPTURE := true
#OMAP_ENHANCEMENT_S3D := true
#OMAP_ENHANCEMENT_CPCAM := true
#OMAP_ENHANCEMENT_VTC := true
OMAP_ENHANCEMENT_MULTIGPU := true
#BOARD_USE_TI_ENHANCED_DOMX := true

PRODUCT_VENDOR_KERNEL_HEADERS := $(COMMON_FOLDER)/kernel-headers

TARGET_SPECIFIC_HEADER_PATH := $(COMMON_FOLDER)/include

# Setup custom omap4xxx defines
BOARD_USE_CUSTOM_LIBION := true

# Hardware
BOARD_HARDWARE_CLASS := device/samsung/tuna/cmhw

# Camera
#TI_OMAP4_CAMERAHAL_VARIANT := true
#TI_CAMERAHAL_USES_LEGACY_DOMX_DCC := true
#TI_CAMERAHAL_MAX_CAMERAS_SUPPORTED := 2
#TI_CAMERAHAL_TREAT_FRONT_AS_BACK := true
#TI_CAMERAHAL_DEBUG_ENABLED := true
#TI_CAMERAHAL_VERBOSE_DEBUG_ENABLED := true
#TI_CAMERAHAL_DEBUG_FUNCTION_NAMES := true
USE_CAMERA_STUB := true

# Use the non-open-source parts, if they're present
-include vendor/samsung/tuna/BoardConfigVendor.mk

# Default values, if not overridden else where.
TARGET_BOARD_INFO_FILE ?= device/samsung/tuna/board-info.txt
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR ?= device/samsung/tuna/bluetooth

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a9

TARGET_NO_BOOTLOADER := true

BOARD_KERNEL_BASE := 0x80000000
# BOARD_KERNEL_CMDLINE :=

# Define kernel config for inline building
TARGET_KERNEL_CONFIG := cyanogenmod_tuna_defconfig
TARGET_KERNEL_SOURCE := kernel/samsung/tuna

TARGET_PREBUILT_KERNEL := device/samsung/tuna/kernel

# External SGX Module
SGX_MODULES:
	make clean -C $(COMMON_FOLDER)/pvr-source/eurasiacon/build/linux2/omap4430_android
	cp $(TARGET_KERNEL_SOURCE)/drivers/video/omap2/omapfb/omapfb.h $(KERNEL_OUT)/drivers/video/omap2/omapfb/omapfb.h
	make -j8 -C $(COMMON_FOLDER)/pvr-source/eurasiacon/build/linux2/omap4430_android ARCH=arm KERNEL_CROSS_COMPILE=arm-eabi- CROSS_COMPILE=arm-eabi- KERNELDIR=$(KERNEL_OUT) TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.0
	mv $(KERNEL_OUT)/../../target/kbuild/pvrsrvkm_sgx540_120.ko $(KERNEL_MODULES_OUT)
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/pvrsrvkm_sgx540_120.ko

TARGET_KERNEL_MODULES += SGX_MODULES

TARGET_NO_RADIOIMAGE := true
TARGET_BOARD_PLATFORM := omap4
TARGET_BOOTLOADER_BOARD_NAME := tuna

# TI Enhancement Settings (Part 2)
ifdef BOARD_USE_TI_ENHANCED_DOMX
    BOARD_USE_TI_DUCATI_H264_PROFILE := true
    BOARD_USE_TI_DOMX_LOW_SECURE_HEAP := true
    COMMON_GLOBAL_CFLAGS += -DENHANCED_DOMX
    ENHANCED_DOMX := true
    TI_CUSTOM_DOMX_PATH := $(COMMON_FOLDER)/domx
    DOMX_PATH := $(COMMON_FOLDER)/domx
else
    DOMX_PATH := hardware/ti/omap4xxx/domx
endif

ifdef OMAP_ENHANCEMENT
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT -DTARGET_OMAP4 -DFORCE_SCREENSHOT_CPU_PATH
endif

ifdef OMAP_ENHANCEMENT_BURST_CAPTURE
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT_BURST_CAPTURE
endif

ifdef OMAP_ENHANCEMENT_S3D
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT_S3D
endif

ifdef OMAP_ENHANCEMENT_CPCAM
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT_CPCAM
    PRODUCT_MAKEFILES += $(LOCAL_DIR)/sdk_addon/ti_omap_addon.mk
endif

ifdef OMAP_ENHANCEMENT_VTC
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT_VTC
endif

ifdef USE_ITTIAM_AAC
    COMMON_GLOBAL_CFLAGS += -DUSE_ITTIAM_AAC
endif

ifdef OMAP_ENHANCEMENT_MULTIGPU
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT_MULTIGPU
endif

BOARD_CREATE_TUNA_HDCP_KEYS_SYMLINK := true

#BOARD_USES_HGL := true
#BOARD_USES_OVERLAY := true
USE_OPENGL_RENDERER := true

# Force the screenshot path to CPU consumer
COMMON_GLOBAL_CFLAGS += -DFORCE_SCREENSHOT_CPU_PATH

# set if the target supports FBIO_WAITFORVSYNC
TARGET_HAS_WAITFORVSYNC := true

# use the new recovery.fstab format
RECOVERY_FSTAB_VERSION=2

TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
TARGET_RECOVERY_UI_LIB := librecovery_ui_tuna
BOARD_RECOVERY_SWIPE := true

# device-specific extensions to the updater binary
TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_tuna
TARGET_RELEASETOOLS_EXTENSIONS := device/samsung/tuna

TARGET_RECOVERY_FSTAB = device/samsung/tuna/fstab.tuna
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 685768704
BOARD_USERDATAIMAGE_PARTITION_SIZE := 14539537408
BOARD_FLASH_BLOCK_SIZE := 4096

# No sync framework for this device...
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true

#TARGET_PROVIDES_INIT_RC := true
#TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

# Wifi related defines
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE           := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"
#WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/bcmdhd.ko"
WIFI_DRIVER_FW_PATH_STA     := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP      := "/vendor/firmware/fw_bcmdhd_apsta.bin"

BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true

# Boot animation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true
TARGET_BOOTANIMATION_USE_RGB565 := true

BOARD_HAL_STATIC_LIBRARIES := libdumpstate.tuna

BOARD_USES_SECURE_SERVICES := true

BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"

BOARD_SEPOLICY_DIRS += \
        device/samsung/tuna/sepolicy

BOARD_SEPOLICY_UNION += \
        genfs_contexts \
        file_contexts
