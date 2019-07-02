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
