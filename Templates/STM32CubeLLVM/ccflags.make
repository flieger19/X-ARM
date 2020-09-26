#
#  cclfags.make
#  STM32CubeLLVM
#
#  Created by Constantin Dullo on 26.09.20.
#

CCFLAGS += -target $(TARGET)
CCFLAGS += -mcpu=$(CPU_TYPE)
CCFLAGS += -m$(CPU_MODE)
CCFLAGS += -mfpu=$(FPU_TYPE)
CCFLAGS += -mfloat-abi=$(FPU_MODE)
CCFLAGS += $(OTHER_DEFINES)
CCFLAGS += -D$(MCU_TYPE)

CCFLAGS += -fmessage-length=0

CCFLAGS += -fdiagnostics-show-note-include-stack

CCFLAGS += -fmacro-backtrace-limit=0

CCFLAGS += -std=gnu11

CCFLAGS += -fmodules
CCFLAGS += -gmodules
CCFLAGS += -fmodules-cache-path=$(FMODULES_CACHE_PATH)
CCFLAGS += -fmodules-prune-interval=86400
CCFLAGS += -fmodules-prune-after=345600

CCFLAGS += -fbuild-session-file=$(FMODULES_CACHE_PATH)/$(FBUILD_SESSION_FILE)

CCFLAGS += -fmodules-validate-once-per-build-session

CCFLAGS += -Wnon-modular-include-in-framework-module
CCFLAGS += -Werror=non-modular-include-in-framework-module
CCFLAGS += -Wno-trigraphs

CCFLAGS += -fpascal-strings
CCFLAGS += -O$(GCC_OPTIMIZATION_LEVEL)
CCFLAGS += -fno-common

CCFLAGS += -Wno-missing-field-initializers
CCFLAGS += -Wno-missing-prototypes
CCFLAGS += -Werror=return-type
CCFLAGS += -Wdocumentation
CCFLAGS += -Wunreachable-code
CCFLAGS += -Wquoted-include-in-framework-header
CCFLAGS += -Werror=deprecated-objc-isa-usage
CCFLAGS += -Werror=objc-root-class
CCFLAGS += -Wno-missing-braces
CCFLAGS += -Wparentheses
CCFLAGS += -Wswitch
CCFLAGS += -Wunused-function
CCFLAGS += -Wno-unused-label
CCFLAGS += -Wno-unused-parameter
CCFLAGS += -Wunused-variable
CCFLAGS += -Wunused-value
CCFLAGS += -Wempty-body
CCFLAGS += -Wuninitialized
CCFLAGS += -Wconditional-uninitialized
CCFLAGS += -Wno-unknown-pragmas
CCFLAGS += -Wno-shadow
CCFLAGS += -Wno-four-char-constants
CCFLAGS += -Wno-conversion
CCFLAGS += -Wconstant-conversion
CCFLAGS += -Wint-conversion
CCFLAGS += -Wbool-conversion
CCFLAGS += -Wenum-conversion
CCFLAGS += -Wno-float-conversion
CCFLAGS += -Wnon-literal-null-conversion
CCFLAGS += -Wobjc-literal-conversion
CCFLAGS += -Wshorten-64-to-32
CCFLAGS += -Wpointer-sign
CCFLAGS += -Wno-newline-eof

CCFLAGS += -D$(GCC_PREPROCESSOR_DEFINITIONS)

CCFLAGS += -isysroot $(SYSROOT)

CCFLAGS += -fasm-blocks
CCFLAGS += -fstrict-aliasing

CCFLAGS += -Wdeprecated-declarations

ifeq ($(CONFIGURATION), Debug)
	CCFLAGS += -g -g$(DEBUG_INFORMATION_FORMAT)-2
endif

CCFLAGS += -Wno-sign-conversion
CCFLAGS += -Winfinite-recursion
CCFLAGS += -Wcomma
CCFLAGS += -Wblock-capture-autoreleasing
CCFLAGS += -Wstrict-prototypes
CCFLAGS += -Wno-semicolon-before-method-body
CCFLAGS += -Wunguarded-availability

CCFLAGS += -index-store-path $(INDEX_STORE_PATH)

CCFLAGS += -iquote $(GENERATED_FILES)
CCFLAGS += -I$(OWN_TARGET_HEADERS)
CCFLAGS += -I$(ALL_TARGET_HEADERS)
CCFLAGS += -iquote $(PROJECT_HEADERS)

CCFLAGS += -I$(TARGET_BUILD_DIR)/include

CCFLAGS += $(HEADER_SEARCH_PATHS)

CCFLAGS += -I$(DERIVED_SOURCES_DIR)-normal/$(ARCHS)
CCFLAGS += -I$(DERIVED_SOURCES_DIR)/$(ARCHS)
CCFLAGS += -I$(DERIVED_SOURCES_DIR)

CCFLAGS += -F$(TARGET_BUILD_DIR)

CCFLAGS += -MMD
CCFLAGS += -MT dependencies