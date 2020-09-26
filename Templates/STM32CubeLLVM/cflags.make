#
#  clfags.make
#  STM32CubeLLVM
#
#  Created by Constantin Dullo on 26.09.20.
#

CFLAGS += -target $(TARGET)
CFLAGS += -mcpu=$(CPU_TYPE)
CFLAGS += -m$(CPU_MODE)
CFLAGS += -mfpu=$(FPU_TYPE)
CFLAGS += -mfloat-abi=$(FPU_MODE)
CFLAGS += $(OTHER_DEFINES)
CFLAGS += -D$(MCU_TYPE)