 #
 # Copyright (c) 2019 Alair Dias Junior.
 # All rights reserved. 
 # 
 # Redistribution and use in source and binary forms, with or without modification, 
 # are permitted provided that the following conditions are met:
 #
 # 1. Redistributions of source code must retain the above copyright notice,
 #    this list of conditions and the following disclaimer.
 # 2. Redistributions in binary form must reproduce the above copyright notice,
 #    this list of conditions and the following disclaimer in the documentation
 #    and/or other materials provided with the distribution.
 # 3. The name of the author may not be used to endorse or promote products
 #    derived from this software without specific prior written permission. 
 #
 # THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED 
 # WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
 # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
 # SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
 # OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 # INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 # CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
 # IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
 # OF SUCH DAMAGE.
 #
 # This file is part of the lwIP porting for Tiva.
 # 
 # Author: Alair Dias Junior <alair@alair.me>
 #
 #

cmake_minimum_required(VERSION 3.10)

set (CMAKE_CONFIGURATION_TYPES "MinSizeRel;Debug;Release")

# avoid CMAKE trying to link during the test run. This is cross-compiling
set (CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

project(lwIP-tiva)

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

