# Specify the minimum version for CMake
cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

# Environment
set(MCU_TYPE "STM32F0" CACHE STRING "set the type of the microcontroller")
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
set(CMAKE_SYSTEM_NAME Generic) 
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING ON)

# add aditional prefiy paths
list(APPEND CMAKE_PREFIX_PATH "$ENV{PATH}" "$ENV{LIBRARY_PATH}" "$ENV{CPATH}" "$ENV{LD_LIBRARY_PATH}")

# Project's name
project(stm32f0xx)
SET(CMAKE_BUILD_TYPE Debug)

# set compiler
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")
SET(CMAKE_C_LINK_EXECUTABLE "arm-none-eabi-ld")
SET(CMAKE_AR "arm-none-eabi-ar")
SET(CMAKE_NM "arm-none-eabi-nm")
SET(CMAKE_OBJCOPY "arm-none-eabi-objcopy")
SET(CMAKE_OBJDUMP "arm-none-eabi-objdump")
SET(CMAKE_RANLIB "arm-none-eabi-ranlib")
SET(CMAKE_STRIP "arm-none-eabi-strip")
    
# set flags
if(${MCU_TYPE} STREQUAL "STM32F0")
    set(CPU_TYPE "-mcpu=cortex-m0")
elseif (${MCU_TYPE} STREQUAL "STM32F1")
    set(CPU_TYPE "-mcpu=cortex-m3")
elseif (${MCU_TYPE} STREQUAL "STM32F2")
    set(CPU_TYPE "-mcpu=cortex-m3")
elseif (${MCU_TYPE} STREQUAL "STM32F3")
    set(CPU_TYPE "-mcpu=cortex-m4")
elseif (${MCU_TYPE} STREQUAL "STM32F4")
    set(CPU_TYPE "-mcpu=cortex-m4")
elseif (${MCU_TYPE} STREQUAL "STM32L1")
    set(CPU_TYPE "-mcpu=cortex-m3")
else()
    message(ERROR "UNKNOWN MICROKONTROLLER TYPE")
endif()
set(CPU_MODE "-mthumb")

set(PTYPE "${MCU_TYPE}_MD")
set(FULLASSERT "-DUSE_FULL_ASSERT")

set(CMAKE_CFLAGS "${CPU_TYPE} ${CPU_MODE} -D${PTYPE} -DUSE_STDPERIPH_DRIVER ${FULLASSERT}")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_CFLAGS} -Wall -g")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_CFLAGS}")

set(CMAKE_EXE_LINKER_FLAGS "${CPU_TYPE} ${CPU_MODE}")

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)

set(core_dir "${PROJECT_SOURCE_DIR}/core")
set(periphery_dir "${PROJECT_SOURCE_DIR}/periphery")

include_directories(${PROJECT_SOURCE_DIR})
include_directories(${core_dir})
include_directories(${periphery_dir})



set(CORE_NAME "${MCU_TYPE}XX")
file(GLOB CORE_HEADERS "${core_dir}/*.h")
file(GLOB CORE_SOURCES "${core_dir}/*.c")
#add_library(${CORE_NAME} STATIC ${CORE_SOURCES} ${CORE_HEADERS})


file(GLOB PERIPHERY_HEADERS "${periphery_dir}/*.h")
file(GLOB PERIPHERY_SOURCES "${periphery_dir}/*.c")

foreach(itt ${PERIPHERY_SOURCES})
    set(SOURCES ${itt})
    get_filename_component(src_file_name ${itt} NAME_WE)
    string(TOUPPER ${src_file_name} LIB_NAME)
    add_library(${LIB_NAME} STATIC ${SOURCES})
endforeach(itt)
