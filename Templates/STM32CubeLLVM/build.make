#
#  definition.make
#  STM32CubeLLVM
#
#  Created by Constantin Dullo on 27.09.20.
#

build: setup $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).elf $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).hex $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).bin

# list of c program objects
OBJECTS += $(addprefix $(INTERMEDIATE_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# list of cpp program objects
OBJECTS += $(addprefix $(INTERMEDIATE_DIR)/,$(notdir $(CPP_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CPP_SOURCES)))

# list of ASM program objects
OBJECTS += $(addprefix $(INTERMEDIATE_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(INTERMEDIATE_DIR)/%.o: %.c Makefile
	$(CC) $(CCFLAGS) -MF $(INTERMEDIATE_DIR)/$*.d --serialize-diagnostics $(INTERMEDIATE_DIR)/$*.dia -c $< -o $@

$(INTERMEDIATE_DIR)/%.o: %.cpp Makefile
	$(CXX) $(CCFLAGS) -MF $(INTERMEDIATE_DIR)/$*.d --serialize-diagnostics $(INTERMEDIATE_DIR)/$*.dia -c $< -o $@

$(INTERMEDIATE_DIR)/%.o: %.s Makefile
	$(AS) $(CCFLAGS) -MF $(INTERMEDIATE_DIR)/$*.d --serialize-diagnostics $(INTERMEDIATE_DIR)/$*.dia -c $< -o $@

$(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).elf: $(OBJECTS) Makefile
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
	$(SZ) $@

$(BUILD_DIR)/$(CONFIGURATION)/%.hex: $(BUILD_DIR)/$(CONFIGURATION)/%.elf | $(BUILD_DIR)/$(CONFIGURATION)
	$(HEX) $< $@

$(BUILD_DIR)/$(CONFIGURATION)/%.bin: $(BUILD_DIR)/$(CONFIGURATION)/%.elf | $(BUILD_DIR)/$(CONFIGURATION)
	$(BIN) $< $@