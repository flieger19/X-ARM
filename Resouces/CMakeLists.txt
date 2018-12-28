# Specify the minimum version for CMake
cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

# Environment
#SET(CMAKE_C_COMPILER_ID qcc)
#SET(CMAKE_CXX_COMPILER_ID QCC)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
#set(CMAKE_SYSTEM_NAME QNX) 
#set(CMAKE_SYSTEM_VERSION 641) 
set(CMAKE_SYSTEM_NAME Generic) 
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING ON)

# disable in source build
#set(CMAKE_DISABLE_SOURCE_CHANGES ON)
#set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

# add aditional prefiy paths
list(APPEND CMAKE_PREFIX_PATH "/usr/local/opt/qt/lib/cmake/Qt5/" "$ENV{QTDIR}/lib/cmake/Qt5/" "$ENV{PATH}" "$ENV{LIBRARY_PATH}" "$ENV{CPATH}" "$ENV{LD_LIBRARY_PATH}" "$ENV{CASROOT}")

# Project's name
project(stm32f0xx)
SET(CMAKE_BUILD_TYPE Debug)

# set compiler
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")
SET(CMAKE_C_LINK_EXECUTABLE "arm-none-eabi-ld")
SET(CMAKE_AR "arm-none-eabi-ar")
#SET(CMAKE_CXX_COMPILER "arm-none-eabi-ld")
#SET(CMAKE_C_COMPILER   "arm-none-eabi-ld")
#SET(CMAKE_LINKER "arm-none-eabi-ld")
SET(CMAKE_NM "arm-none-eabi-nm")
SET(CMAKE_OBJCOPY "arm-none-eabi-objcopy")
SET(CMAKE_OBJDUMP "arm-none-eabi-objdump")
SET(CMAKE_RANLIB "arm-none-eabi-ranlib")
SET(CMAKE_STRIP "arm-none-eabi-strip")
    
# set flags
set(CPU_TYPE "-mcpu=cortex-m0")
set(CPU_MODE "-mthumb")

set(PTYPE "STM32F0XX_MD")
set(FULLASSERT "-DUSE_FULL_ASSERT")

set(CMAKE_CFLAGS "${CPU_TYPE} ${CPU_MODE} -D${PTYPE} -DUSE_STDPERIPH_DRIVER ${FULLASSERT}")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_CFLAGS} -Wall -g")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_CFLAGS}")

set(CMAKE_EXE_LINKER_FLAGS "${CPU_TYPE} ${CPU_MODE}")

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)
set(SOURCE_DIR ${PROJECT_SOURCE_DIR}/src)

set(core_dir "core")
set(periphery_dir "periphery")

include_directories(${INCLUDE_DIR})
include_directories(${INCLUDE_DIR}/${core_dir})
include_directories(${INCLUDE_DIR}/${periphery_dir})

set(CORE_NAME "STM32F0XX")
set(CORE_HEADERS ${INCLUDE_DIR}/${core_dir}/stm32f0xx.h ${INCLUDE_DIR}/${core_dir}/system_stm32f0xx.h ${INCLUDE_DIR}/${core_dir}/core_cm0.h ${INCLUDE_DIR}/${core_dir}/stm32f0xx_conf.h ${INCLUDE_DIR}/${core_dir}/core_cmInstr.h ${INCLUDE_DIR}/${core_dir}/core_cmFunc.h)
set(CORE_SOURCES ${SOURCE_DIR}/${core_dir}/startup_stm32f0xx.c ${SOURCE_DIR}/${core_dir}/system_stm32f0xx.c)
add_library(${CORE_NAME} STATIC ${CORE_SOURCES} ${CORE_HEADERS})
#set_target_properties(${CORE_NAME} PROPERTIES LINKER_LANGUAGE C)
  
set(PERIPHERY_NAME "ADC" "I2C" "SPI" "CAN" "DBGMCU" "IWDG" "SYSCFG" "CEC" "DMA" "MISC" "TIM" "COMP" "EXTI" "PWR" "USART" "CRC" "FLASH" "RCC" "WWDG" "CRS" "GPIO" "RTC") #"DAC" 

foreach(itt ${PERIPHERY_NAME})
    set(SOURCES ${SOURCE_DIR}/${periphery_dir}/stm32f0xx_${itt}.c)
    set(HEADERS ${INCLUDE_DIR}/${periphery_dir}/stm32f0xx_${itt}.h)
    add_library(${CORE_NAME}_${itt} STATIC ${SOURCES} ${HEADERS})
endforeach(itt)
