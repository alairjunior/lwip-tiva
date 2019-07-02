# This file is indended to be included in end-user CMakeLists.txt
# include(/path/to/Filelists.cmake)
#
# This file is NOT designed (on purpose) to be used as cmake
# subdir via add_subdirectory()
# The intention is to provide greater flexibility to users to
# create their own targets using the *_SRCS variables.

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.10.0")
    include_guard(GLOBAL)
endif()

set (lwipcontribporttiva_SRCS
    ${LWIP_PORT_DIR}/ports/tiva-tm4c1294/port/sys_arch.c
    ${LWIP_PORT_DIR}/ports/tiva-tm4c1294/port/perf.c
    ${LWIP_PORT_DIR}/ports/tiva-tm4c1294/port/lwiplib.c
)

set (lwipcontribporttivanetifs_SRCS
    ${LWIP_PORT_DIR}/ports/tiva-tm4c1294/port/netif/tiva-tm4c129.c
)

add_library(lwipcontribporttiva EXCLUDE_FROM_ALL ${lwipcontribporttiva_SRCS} ${lwipcontribporttivanetifs_SRCS})
target_include_directories(lwipcontribporttiva PRIVATE ${LWIP_INCLUDE_DIRS})
target_compile_options(lwipcontribporttiva PRIVATE ${LWIP_COMPILER_FLAGS})
target_compile_definitions(lwipcontribporttiva PRIVATE ${LWIP_DEFINITIONS})
target_link_libraries(lwipcontribporttiva)

