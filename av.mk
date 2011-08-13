# LOCAL_PATH is one of libavutil, libavcodec, libavformat, or libswscale

SRC_PATH := $(ffmpeg_TOPDIR)
include $(SRC_PATH)/config-$(TARGET_ARCH_VARIANT).mak
ifneq ($(LOCAL_PATH),$(ffmpeg_TOPDIR))
ifneq ($(subst $(ffmpeg_TOPDIR),,$(LOCAL_PATH)),$(LOCAL_PATH))

OBJS :=
OBJS-yes :=
MMX-OBJS-yes :=
SUBDIR := $(LOCAL_PATH)/
include $(LOCAL_PATH)/Makefile
ifeq ($(NAME),avcodec)
include $(LOCAL_PATH)/$(TARGET_ARCH)/Makefile
endif

# collect objects
OBJS-$(HAVE_MMX) += $(MMX-OBJS-yes)
OBJS += $(OBJS-yes)

FFNAME := lib$(NAME)
FFLIBS := $(foreach,NAME,$(FFLIBS),lib$(NAME))

ALL_S_FILES := $(wildcard $(LOCAL_PATH)/$(TARGET_ARCH)/*.S)
ALL_S_FILES := $(addprefix $(TARGET_ARCH)/, $(notdir $(ALL_S_FILES)))

ifneq ($(ALL_S_FILES),)
ALL_S_OBJS := $(patsubst %.S,%.o,$(ALL_S_FILES))
C_OBJS := $(filter-out $(ALL_S_OBJS),$(OBJS))
S_OBJS := $(filter $(ALL_S_OBJS),$(OBJS))
else
C_OBJS := $(OBJS)
S_OBJS :=
endif

C_FILES := $(patsubst %.o,%.c,$(C_OBJS))
S_FILES := $(patsubst %.o,%.S,$(S_OBJS))

FFFILES := $(sort $(S_FILES)) $(sort $(C_FILES))
LOCAL_CFLAGS += -DHAVE_AV_CONFIG_H
endif
endif

LOCAL_CFLAGS += $(FFCPPFLAGS) -include $(ffmpeg_TOPDIR)/config-$(TARGET_ARCH_VARIANT).h $(FFCFLAGS) -std=gnu99 -Wno-error=return-type -Wno-error=format-security
