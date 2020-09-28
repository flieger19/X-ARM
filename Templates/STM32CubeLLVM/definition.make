#
#  definition.make
#  STM32CubeLLVM
#
#  Created by Constantin Dullo on 25.09.20.
#

# C sources
C_SOURCES := \
	$(shell find $(PROJECT_DIR)/$(PROJECT_NAME)/Core/Src -name '*.c') \
	$(shell find $(PROJECT_DIR)/$(PROJECT_NAME)/Drivers/$(MCU_FAMILY)_HAL_Driver/Src -name '*.c')

# C++ sources
CPP_SOURCES := $(shell find $(PROJECT_DIR)/$(PROJECT_NAME)/Core/Src -name '*.cpp')

# ASM sources
ASM_SOURCES := $(shell find $(PROJECT_DIR)/$(PROJECT_NAME) -name '*.s')

# Additional definitions
FMODULES_CACHE_PATH = $(HOME)/Library/Developer/Xcode/DerivedData/ModuleCache.noindex
FBUILD_SESSION_FILE = Session.modulevalidation
INDEX_DIR = $(BUILD_ROOT)/../../Index/
INDEX_STORE_PATH = $(INDEX_DIR)/DataStore
TARGET_TEMP_DIR = $(CONFIGURATION_TEMP_DIR)/$(PROJECT_NAME).build
GENERATED_FILES = $(TARGET_TEMP_DIR)/$(PROJECT_NAME)-generated-files.hmap
OWN_TARGET_HEADERS = $(TARGET_TEMP_DIR)/$(PROJECT_NAME)-own-target-headers.hmap
ALL_TARGET_HEADERS = $(TARGET_TEMP_DIR)/$(PROJECT_NAME)-all-target-headers.hmap
PROJECT_HEADERS = $(TARGET_TEMP_DIR)/$(PROJECT_NAME)-project-headers.hmap
INTERMEDIATE_DIR = $(TARGET_TEMP_DIR)/Objects-normal/$(ARCHS)
DERIVED_SOURCES_NORMAL = $(TARGET_TEMP_DIR)/DerivedSources-normal
DERIVED_SOURCES = $(TARGET_TEMP_DIR)/DerivedSources

# binary definitions
CC = $(TOOLCHAIN_DIR)/usr/bin/clang
CXX = $(TOOLCHAIN_DIR)/usr/bin/clang++
AS = $(TOOLCHAIN_DIR)/usr/bin/clang -x assembler-with-cpp
CP = $(TOOLCHAIN_DIR)/usr/bin/llvm-objcopy
SZ = $(TOOLCHAIN_DIR)/usr/bin/llvm-size

HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

setup:
	mkdir -p $(INTERMEDIATE_DIR)
	mkdir -p $(DERIVED_SOURCES_NORMAL)/$(ARCHS)
	mkdir -p $(DERIVED_SOURCES)/$(ARCHS)

include ccflags.make
include ldflags.make