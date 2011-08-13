LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

include $(ffmpeg_TOPDIR)/av.mk

LOCAL_SRC_FILES := $(FFFILES)

LOCAL_C_INCLUDES :=		\
	$(LOCAL_PATH)		\
	$(ffmpeg_TOPDIR)	\
	external/zlib

#LOCAL_CFLAGS += -include "string.h" -Dipv6mr_interface=ipv6mr_ifindex

LOCAL_SHARED_LIBRARIES := libz libavutil libavcodec

LOCAL_MODULE := $(FFNAME)
LOCAL_MODULE_TAGS := eng
LOCAL_PRELINK_MODULE := false

include $(BUILD_SHARED_LIBRARY)
