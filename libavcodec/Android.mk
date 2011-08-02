LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

include $(LOCAL_PATH)/../av.mk

LOCAL_SRC_FILES := $(FFFILES)

LOCAL_C_INCLUDES :=		\
	$(LOCAL_PATH)		\
	$(LOCAL_PATH)/..	\
	external/zlib

LOCAL_CFLAGS += $(FFCFLAGS)

LOCAL_SHARED_LIBRARIES := libz libavutil
LOCAL_MODULE_TAGS := optional

LOCAL_MODULE := $(FFNAME)
LOCAL_PRELINK_MODULE := false

include $(BUILD_SHARED_LIBRARY)
