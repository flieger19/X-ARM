#
#  ldlfags.make
#  STM32CubeLLVM
#
#  Created by Constantin Dullo on 27.09.20.
#

LDFLAGS += -target $(TARGET)
LDFLAGS += -mcpu=$(CPU_TYPE)
LDFLAGS += -m$(CPU_MODE)
LDFLAGS += -mfpu=$(FPU_TYPE)
LDFLAGS += -mfloat-abi=$(FPU_MODE)
LDFLAGS += -specs=$(SPECS)
LDFLAGS += -T $(SRCROOT)/$(PROJECT_NAME)/$(LDSCRIPT)
LDFLAGS += $(SYSROOT)/usr/lib/crti.o

LDFLAGS += -isysroot $(SYSROOT)

LDFLAGS += -L$(LIBRARY_SEARCH_PATHS)
LDFLAGS += -L$(TARGET_BUILD_DIR)
LDFLAGS += -F$(TARGET_BUILD_DIR)