#
#  definition.make
#  STM32CubeLLVM
#
#  Created by Constantin Dullo on 25.09.20.
#

# Additional definitions
FMODULES_CACHE_PATH = $(HOME)/Library/Developer/Xcode/DerivedData/ModuleCache.noindex
FBUILD_SESSION_FILE = Session.modulevalidation
INDEX_DIR = $(BUILD_ROOT)/../../Index/
INDEX_STORE_PATH = $(INDEX_DIR)/DataStore
GENERATED_FILES = $(OBJROOT)/xCubeTest.build/Debug/Index.build/xCubeTest-generated-files.hmap
OWN_TARGET_HEADERS = $(OBJROOT)/xCubeTest.build/Debug/Index.build/xCubeTest-own-target-headers.hmap
ALL_TARGET_HEADERS = $(OBJROOT)/xCubeTest.build/Debug/Index.build/xCubeTest-all-target-headers.hmap
PROJECT_HEADERS = $(OBJROOT)/xCubeTest.build/Debug/Index.build/xCubeTest-project-headers.hmap

# binary definitions
CC = $(TOOLCHAIN_DIR)/usr/bin/clang
CXX = $(TOOLCHAIN_DIR)/usr/bin/clang++
AS = $(TOOLCHAIN_DIR)/usr/bin/clang -x assembler-with-cpp
CP = $(TOOLCHAIN_DIR)/usr/bin/llvm-objcopy
SZ = $(TOOLCHAIN_DIR)/usr/bin/llvm-size

HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

include cflags.make