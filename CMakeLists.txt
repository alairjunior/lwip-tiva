cmake_minimum_required(VERSION 3.10)

set (CMAKE_CONFIGURATION_TYPES "MinSizeRel;Debug;Release")

# avoid CMAKE trying to link during the test run. This is cross-compiling
set (CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

project(lwIP)

# Example lwIP application
set(LWIP_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../lwip)
set(LWIP_PORT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set (LWIP_DEFINITIONS LWIP_DEBUG=1)

# TivaWare Configuration
set(TIVAWARE_DIR "~/embedded/tivaware")
set(TOOLCHAIN_PREFIX arm-none-eabi)
set(PART TM4C1294NCPDT)
set(PLATFORM_COMPILER_FLAGS -DTARGET_IS_TM4C129_RA0 -DPART_${PART} -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -MD -fno-exceptions --specs=nosys.specs -fdata-sections -ffunction-sections)
set(PLATFORM_LINKER_FLAGS -DTARGET_IS_TM4C129_RA0 -DPART_${PART} -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -MD -fno-exceptions --specs=nosys.specs -fdata-sections -ffunction-sections)
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}-objcopy)
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++)

# Set the target system name
set(CMAKE_SYSTEM_NAME tiva-tm4c1294)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/ports/${CMAKE_SYSTEM_NAME}/enet_lwip)

