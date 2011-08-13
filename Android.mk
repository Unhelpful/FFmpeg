ffmpeg_SUBMKS := $(call all-subdir-makefiles)
ffmpeg_TOPDIR := $(call my-dir)
LOCAL_PATH := $(ffmpeg_TOPDIR)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := ffprobe.c cmdutils.c
LOCAL_C_INCLUDES += $(LOCAL_PATH)
include $(ffmpeg_TOPDIR)/av.mk
LOCAL_SHARED_LIBRARIES += libavutil libavformat libavcodec
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE := ffprobe
include $(BUILD_EXECUTABLE)
include $(ffmpeg_SUBMKS)
