#
#  clean.make
#  STM32CubeLLVM
#
#  Created by Constantin Dullo on 27.09.20.
#

clean:
	rm -f $(OBJECTS) $(OBJECTS:.o=.d) $(OBJECTS:.o=.dia) $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).elf $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).hex $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).bin