#----------------------------------------------------------------------------
# On command line:
#
# make all = Make software.
#
# make clean = Clean out built project files.
#
# make coff = Convert ELF to AVR COFF.
#
# make extcoff = Convert ELF to AVR Extended COFF.
#
# make program = Download the hex file to the device, using avrdude.
#                Please customize the avrdude settings below first!
#
# make debug = Start either simulavr or avarice as specified for debugging, 
#              with avr-gdb or avr-insight as the front end for debugging.
#
# make filename.s = Just compile filename.c into the assembler code only.
#
# make filename.i = Create a preprocessed source file for use in submitting
#                   bug reports to the GCC project.
#
# To rebuild project do "make clean" then "make all".
#----------------------------------------------------------------------------

#include conf.mk
# MICROCONTROLLER name
MICROCONTROLLER = stm32f0xx

# name of the link programmer
LINK_PROGRAMMER = st-link

# Output format. (can be srec, ihex, binary)
FORMAT = ihex


# Target file name (without extension).
TARGET = main


# List C source files here. (C dependencies are automatically generated.)

SRC = $(wildcard *.c)

OBJDIR = Builds
# List Assembler source files here.
#     Make them always end in a capital .S.  Files ending in a lowercase .s
#     will not be considered source files but generated files (assembler
#     output from the compiler), and will be deleted upon "make clean"!
#     Even though the DOS/Win* filesystem matches both .s and .S the same,
#     it will preserve the spelling of the filenames, and gcc itself does
#     care about how the name is spelled on its command-line.
ASRC = $(wildcard *.S)


# Optimization level, can be [0, 1, 2, 3, s]. 
#     0 = turn off optimization. s = optimize for size.
#     (Note: 3 is not always the best optimization level. See avr-libc FAQ.)
OPT = 0


# Debugging format.
#     Native formats for AVR-GCC's -g are dwarf-2 [default] or stabs.
#     AVR Studio 4.10 requires dwarf-2.
#     AVR [Extended] COFF format requires stabs, plus an avr-objcopy run.
DEBUG =


# List any extra directories to look for include files here.
#     Each directory must be seperated by a space.
#     Use forward slashes for directory separators.
#     For a directory that has spaces, enclose it in quotes.
EXTRAINCDIRS =

#---------------- Compiler Options ----------------
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual and avr-libc documentation
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
CFLAGS = -g$(DEBUG)
CFLAGS += -O$(OPT)
CFLAGS += -mcpu=cortex-m0 -mthumb
CFLAGS += -Wall
CFLAGS += -I$(HEADER_SEARCH_PATHS)
CFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))
CFLAGS += $(CSTANDARD)
CFLAGS += -DSTM32F0XX_MD -DUSE_STDPERIPH_DRIVER -DUSE_FULL_ASSERT

#---------------- Assembler Options ----------------
#  -Wa,...:   tell GCC to pass this to the assembler.
#  -ahlms:    create listing
#  -gstabs:   have the assembler create line number information; note that
#             for use in COFF files, additional information about filenames
#             and function names needs to be present in the assembler source
#             files -- see avr-libc docs [FIXME: not yet described there]
#  -listing-cont-lines: Sets the maximum number of continuation lines of hex 
#       dump that will be displayed for a given single line of source input.
ASFLAGS =

#---------------- Library Options ----------------
#  import Xcode library flags
LDLIBS = $(OTHER_LINKER_FLAGS)

#---------------- Linker Options ----------------
#  define linker script
LDSCRIPT = LDScript.ld

#  setup linker flags
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS += -T$(LDSCRIPT)
LDFLAGS += -mthumb -mcpu=cortex-m0
LDFLAGS += -L$(LIBRARY_SEARCH_PATHS)
LDFLAGS += $(patsubst %,-L%,$(EXTRAINCDIRS))

#---------------- Programming Options ----------------

#---------------- Debugging Options ----------------
# GDB Init Filename.
GDBINIT_FILE = __avr_gdbinit

# Debugging port used to communicate between GDB / avarice / simulavr.
DEBUG_PORT = 4242


#============================================================================


# Define programs and commands.
SHELL = sh
CC = {arm-none-eabi-gcc_loc}
LD = {arm-none-eabi-gcc_loc}
AR = {arm-none-eabi-ar_loc}
AS = {arm-none-eabi-as_loc}
OBJCOPY = {arm-none-eabi-objcopy_loc}
OBJDUMP = {arm-none-eabi-objdump_loc}
SIZE = {arm-none-eabi-size_loc}
NM = {arm-none-eabi-nm_loc}
GDB = {arm-none-eabi-gdb_loc}
LINK = st-util
REMOVE = rm -f
COPY = cp

# Define all object files.
OBJ = $(addprefix $(OBJDIR)/,$(SRC:.c=.o)) $(addprefix $(OBJDIR)/,$(ASRC:.S=.o))

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_CFLAGS = -I. $(CFLAGS)
ALL_ASFLAGS = -I. -x assembler-with-cpp $(ASFLAGS)

# Generate dependency files
DEPS      = $(SRC:%.c=$(OBJDIR)/%.d)

-include $(DEPS)

.DELETE_ON_ERROR:
$(DEPSDIR)/%.d: %.c | $(DEPSDIR)
	$(CC) $(ALL_ASFLAGS) $(GENDEPFLAGS) -MT $(patsubst %.c,$(OBJDIR)/%.o,$<) -MF $@ $<


# Default target.
all: clean build program debug

build: $(OBJDIR) elf #hex

#bin: $(OBJDIR)/$(TARGET).bin
elf: $(OBJDIR)/$(TARGET).elf
#hex: $(OBJDIR)/$(TARGET).hex

$(OBJDIR):
	@mkdir -p $@

# Program the device.
program:
	@exec $(LINK) &

# Generate arm-gdb config/init file which does the following:
#     define the reset signal, load the target file, connect to target, and set
#     a breakpoint at main().
gdb-config:
	@$(REMOVE) $(GDBINIT_FILE)
	@echo file $(OBJDIR)/$(TARGET).elf >> $(GDBINIT_FILE)
	@echo target extended-remote :$(DEBUG_PORT)  >> $(GDBINIT_FILE)
	@echo load  >> $(GDBINIT_FILE)
	@echo continue >> $(GDBINIT_FILE)

debug: gdb-config $(OBJDIR)/$(TARGET).elf
	@$(GDB) -x $(GDBINIT_FILE)

# Link: create ELF output file from object files.
.SECONDARY : $(OBJDIR)/$(TARGET).elf
.PRECIOUS : $(OBJ)
$(OBJDIR)/%.elf: $(OBJ)
	$(CC) $(LDFLAGS) $^ -o $@ $(LDLIBS)


# Compile: create object files from C source files.
$(OBJDIR)/%.o : %.c
	$(CC) -c $(ALL_CFLAGS) "$(abspath $<)" -o $@
	$(CC) -MM $(ALL_CFLAGS) $< > $(OBJDIR)/$*.d


# Compile: create assembler files from C source files.
$(OBJDIR)/%.s : %.c
	$(CC) -S $(ALL_CFLAGS) $< -o $@


# Assemble: create object files from assembler source files.
$(OBJDIR)/%.o : %.S
	$(CC) -c $(ALL_ASFLAGS) $< -o $@

# Create preprocessed source for use in sending a bug report.
$(OBJDIR)/%.i : %.c
	$(CC) -E -I. $(CFLAGS) $< -o $@ 


# Target: clean project.
clean: clean_list

clean_list :
	#$(REMOVE) $(OBJDIR)/$(TARGET).hex
	$(REMOVE) $(OBJDIR)/$(TARGET).elf
	#$(REMOVE) $(OBJDIR)/$(TARGET).map
	$(REMOVE) $(OBJ)
	$(REMOVE) $(LST)
	$(REMOVE) $(OBJDIR)/$(SRC:.c=.s)
	$(REMOVE) $(OBJDIR)/$(SRC:.c=.d)

