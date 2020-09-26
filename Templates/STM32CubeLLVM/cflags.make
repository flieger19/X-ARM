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

CFLAGS += -fmessage-length=0

CFLAGS += -fdiagnostics-show-note-include-stack

CFLAGS += -fmacro-backtrace-limit=0

CFLAGS += -std=gnu11

CFLAGS += -fmodules
CFLAGS += -gmodules
CFLAGS += -fmodules-cache-path=$(FMODULES_CACHE_PATH)
CFLAGS += -fmodules-prune-interval=86400
CFLAGS += -fmodules-prune-after=345600

CFLAGS += -fbuild-session-file=$(FMODULES_CACHE_PATH)/$(FBUILD_SESSION_FILE)

CFLAGS += -fmodules-validate-once-per-build-session

CFLAGS += -Wnon-modular-include-in-framework-module
CFLAGS += -Werror=non-modular-include-in-framework-module
CFLAGS += -Wno-trigraphs

CFLAGS += -fpascal-strings
CFLAGS += -O$(GCC_OPTIMIZATION_LEVEL)
CFLAGS += -fno-common

CFLAGS += -Wno-missing-field-initializers
CFLAGS += -Wno-missing-prototypes
CFLAGS += -Werror=return-type
CFLAGS += -Wdocumentation
CFLAGS += -Wunreachable-code
CFLAGS += -Wquoted-include-in-framework-header
CFLAGS += -Werror=deprecated-objc-isa-usage
CFLAGS += -Werror=objc-root-class
CFLAGS += -Wno-missing-braces
CFLAGS += -Wparentheses
CFLAGS += -Wswitch
CFLAGS += -Wunused-function
CFLAGS += -Wno-unused-label
CFLAGS += -Wno-unused-parameter
CFLAGS += -Wunused-variable
CFLAGS += -Wunused-value
CFLAGS += -Wempty-body
CFLAGS += -Wuninitialized
CFLAGS += -Wconditional-uninitialized
CFLAGS += -Wno-unknown-pragmas
CFLAGS += -Wno-shadow
CFLAGS += -Wno-four-char-constants
CFLAGS += -Wno-conversion
CFLAGS += -Wconstant-conversion
CFLAGS += -Wint-conversion
CFLAGS += -Wbool-conversion
CFLAGS += -Wenum-conversion
CFLAGS += -Wno-float-conversion
CFLAGS += -Wnon-literal-null-conversion
CFLAGS += -Wobjc-literal-conversion
CFLAGS += -Wshorten-64-to-32
CFLAGS += -Wpointer-sign
CFLAGS += -Wno-newline-eof

CFLAGS += -D$(GCC_PREPROCESSOR_DEFINITIONS)

CFLAGS += -isysroot $(SYSROOT)

CFLAGS += -fasm-blocks
CFLAGS += -fstrict-aliasing

CFLAGS += -Wdeprecated-declarations

ifeq ($(CONFIGURATION), Debug)
	CFLAGS += -g -g$(DEBUG_INFORMATION_FORMAT)-2
endif

CFLAGS += -Wno-sign-conversion
CFLAGS += -Winfinite-recursion
CFLAGS += -Wcomma
CFLAGS += -Wblock-capture-autoreleasing
CFLAGS += -Wstrict-prototypes
CFLAGS += -Wno-semicolon-before-method-body
CFLAGS += -Wunguarded-availability

CFLAGS += -index-store-path $(INDEX_STORE_PATH)

CFLAGS += -iquote $(GENERATED_FILES)
CFLAGS += -I$(OWN_TARGET_HEADERS)
CFLAGS += -I$(ALL_TARGET_HEADERS)
CFLAGS += -iquote $(PROJECT_HEADERS)

CFLAGS += -I$(TARGET_BUILD_DIR)/include

CFLAGS += $(HEADER_SEARCH_PATHS)

CFLAGS += -I$(DERIVED_SOURCES_DIR)-normal/$(ARCHS)
CFLAGS += -I$(DERIVED_SOURCES_DIR)/$(ARCHS)
CFLAGS += -I$(DERIVED_SOURCES_DIR)

CFLAGS += -F$(TARGET_BUILD_DIR)

CFLAGS += -MMD
CFLAGS += -MT dependencies