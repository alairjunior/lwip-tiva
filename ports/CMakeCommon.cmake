 #
 # Copyright (c) 2001, 2002 Swedish Institute of Computer Science.
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
 # This file was modified from the one provided as part of the lwIP TCP/IP stack.
 # 
 # Original Author: Adam Dunkels <adam@sics.se>
 # Modification: Alair Dias Junior <alair@alair.me>
 # 

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.10.0")
    include_guard(GLOBAL)
endif()

if(NOT CMAKE_BUILD_TYPE)
    message(STATUS  "CMAKE_BUILD_TYPE not set - defaulting to MinSizeRel build.")
    set(CMAKE_BUILD_TYPE MinSizeRel CACHE STRING "Choose the type of build, options are: ${CMAKE_CONFIGURATION_TYPES}." FORCE)
endif()
message (STATUS "Build type: ${CMAKE_BUILD_TYPE}")

set(LWIP_CONTRIB_DIR ${LWIP_DIR}/contrib)

# ARM mbedtls support https://tls.mbed.org/
if(NOT DEFINED LWIP_MBEDTLSDIR)
    set(LWIP_MBEDTLSDIR ${LWIP_DIR}/../mbedtls)
    message(STATUS "LWIP_MBEDTLSDIR not set - using default location ${LWIP_MBEDTLSDIR}")
endif()

if(EXISTS ${LWIP_MBEDTLSDIR}/CMakeLists.txt)
    set(LWIP_HAVE_MBEDTLS ON BOOL)

    # Prevent building MBEDTLS programs and tests
    set(ENABLE_PROGRAMS OFF CACHE BOOL "")
    set(ENABLE_TESTING  OFF CACHE BOOL "")

    # mbedtls uses cmake. Sweet!
    add_subdirectory(${LWIP_MBEDTLSDIR} mbedtls)

    set (LWIP_MBEDTLS_DEFINITIONS
        LWIP_HAVE_MBEDTLS=1
    )
    set (LWIP_MBEDTLS_INCLUDE_DIRS
        ${LWIP_MBEDTLSDIR}/include
    )
    set (LWIP_MBEDTLS_LINK_LIBRARIES
        mbedtls
        mbedcrypto
        mbedx509
    )
endif()

# removed the warning flags as this is copied directly from
# the repository. No need to warning about things we do not have
# control in this port (Alair)
set(LWIP_COMPILER_FLAGS_GNU_CLANG
    $<$<CONFIG:Debug>:-Og>
    $<$<CONFIG:Debug>:-g>
    $<$<CONFIG:Release>:-O3>
    -Wno-unused-parameter
    -Wno-unused-variable
    -Wno-unused-function
    ${PLATFORM_COMPILER_FLAGS}
)

if (NOT LWIP_HAVE_MBEDTLS)
    list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
        -Wredundant-decls
        $<$<COMPILE_LANGUAGE:C>:-Wc++-compat>
    )
endif()

if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
        -Wlogical-op
        -Wtrampolines
    )

    if(NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 4.9)
        if(LWIP_USE_SANITIZERS)
            list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
                -fsanitize=address
                -fsanitize=undefined
                -fno-sanitize=alignment
                -fstack-protector
                -fstack-check
            )
            set(LWIP_SANITIZER_LIBS asan ubsan)
        endif()
    endif()

    set(LWIP_COMPILER_FLAGS ${LWIP_COMPILER_FLAGS_GNU_CLANG})
endif()

if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
    list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
        -Wdocumentation
        -Wno-documentation-deprecated-sync
    )

    if(LWIP_USE_SANITIZERS)
        list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
            -fsanitize=address
            -fsanitize=undefined
            -fno-sanitize=alignment
        )
        set(LWIP_SANITIZER_LIBS asan ubsan)
    endif()

    set(LWIP_COMPILER_FLAGS ${LWIP_COMPILER_FLAGS_GNU_CLANG})
endif()

if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    set(LWIP_COMPILER_FLAGS
        $<$<CONFIG:Debug>:/Od>
        $<$<CONFIG:Release>:/Ox>
        /Wall
        /WX
    )
endif()
