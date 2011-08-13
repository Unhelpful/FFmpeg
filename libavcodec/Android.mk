LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

include $(ffmpeg_TOPDIR)/av.mk

LOCAL_SRC_FILES := $(FFFILES)

LOCAL_C_INCLUDES :=		\
	$(LOCAL_PATH)		\
	$(ffmpeg_TOPDIR)	\
	external/zlib

LOCAL_SHARED_LIBRARIES := libz libavutil
LOCAL_MODULE_TAGS := eng

LOCAL_MODULE := $(FFNAME)
LOCAL_PRELINK_MODULE := false

include $(BUILD_SHARED_LIBRARY)
