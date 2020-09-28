#
#  upload.make
#  STM32CubeLLVM
#
#  Created by Constantin Dullo on 27.09.20.
#

upload:
	st-flash write $(BUILD_DIR)/$(CONFIGURATION)/$(PROJECT_NAME).elf 0x8000000