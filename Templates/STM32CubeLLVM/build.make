#
#  definition.make
#  STM32CubeLLVM
#
#  Created by Constantin Dullo on 27.09.20.
#

build: $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).elf $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).hex $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).bin

# list of c program objects
OBJECTS += $(addprefix $(INTERMEDIATE_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# list of cpp program objects
OBJECTS += $(addprefix $(INTERMEDIATE_DIR)/,$(notdir $(CPP_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(CPP_SOURCES)))

# list of ASM program objects
OBJECTS += $(addprefix $(INTERMEDIATE_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).elf: $(OBJECTS) Makefile
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
	$(SZ) $@