include(${LWIP_PORT_DIR}/ports/CMakeCommon.cmake)

set (LWIP_INCLUDE_DIRS
    "${LWIP_DIR}/src/include"
    "${LWIP_DIR}/contrib/"
    "${LWIP_PORT_DIR}/ports/tiva-tm4c1294/port/include"
    "${LWIP_PORT_DIR}/ports/tiva-tm4c1294/enet_lwip"
    "${TIVAWARE_DIR}"
)

#
# TIVAWARE EXTRA SRCS
#

set (TIVAWARE_INCLUDE_DIRS
    "${LWIP_DIR}/src/include"
    "${LWIP_PORT_DIR}/ports/tiva-tm4c1294/port/include"
    "${LWIP_PORT_DIR}/ports/tiva-tm4c1294/enet_lwip"
    "${TIVAWARE_DIR}"
)

set(TIVAWARE_COMPILER_FLAGS
    $<$<CONFIG:Debug>:-Og>
    $<$<CONFIG:Debug>:-g>
    $<$<CONFIG:Release>:-O3>
    -Wno-incompatible-pointer-types
    ${PLATFORM_COMPILER_FLAGS}
)

set (tivawaredriverlib_SRCS
    ${TIVAWARE_DIR}/utils/ustdlib.c
    ${TIVAWARE_DIR}/utils/uartstdio.c
    ${TIVAWARE_DIR}/utils/locator.c
    ${TIVAWARE_DIR}/driverlib/emac.c
)

add_library(tivawaredriverlib EXCLUDE_FROM_ALL ${tivawaredriverlib_SRCS})
target_include_directories(tivawaredriverlib SYSTEM PRIVATE ${TIVAWARE_INCLUDE_DIRS})
target_compile_options(tivawaredriverlib PRIVATE ${TIVAWARE_COMPILER_FLAGS})
target_link_libraries(tivawaredriverlib)

#
# EXAMPLE SRCS
#

set (EXAMPLE_INCLUDE_DIRS
    "${LWIP_DIR}/src/include"
    "${LWIP_DIR}/contrib/"
    "${LWIP_PORT_DIR}/ports/tiva-tm4c1294/port/include"
    "${LWIP_PORT_DIR}/ports/tiva-tm4c1294/enet_lwip"
    "${TIVAWARE_DIR}"
)

set(EXAMPLE_COMPILER_FLAGS
    $<$<CONFIG:Debug>:-Og>
    $<$<CONFIG:Debug>:-g>
    $<$<CONFIG:Release>:-O3>
    -Wall
    -pedantic
    -Wparentheses
    -Wsequence-point
    -Wswitch-default
    -Wextra
    -Wundef
    -Wshadow
    -Wpointer-arith
    -Wcast-qual
    -Wwrite-strings
     $<$<COMPILE_LANGUAGE:C>:-Wold-style-definition>
    -Wcast-align
    -Wunused-variable
    -Wunreachable-code
    -Wuninitialized
    -Waggregate-return
    -Wlogical-not-parentheses
    ${PLATFORM_COMPILER_FLAGS}
)

set(enet_lwip_SRCS
    ${LWIP_PORT_DIR}/ports/tiva-tm4c1294/enet_lwip/enet_lwip.c
    ${LWIP_PORT_DIR}/ports/tiva-tm4c1294/enet_lwip/startup.c
    ${LWIP_PORT_DIR}/ports/tiva-tm4c1294/enet_lwip/drivers/pinout.c
)



include(${LWIP_DIR}/src/Filelists.cmake)
include(${LWIP_DIR}/contrib/Filelists.cmake)
include(${LWIP_PORT_DIR}/ports/tiva-tm4c1294/Filelists.cmake)

find_library(TIVAWARE_LIBRARY driver HINTS "${TIVAWARE_DIR}/driverlib/gcc")

set(LINKER_SCRIPT ${LWIP_PORT_DIR}/ports/tiva-tm4c1294/enet_lwip/enet_lwip.ld)
set(ENTRY ResetISR)

add_executable(enet_lwip.axf ${enet_lwip_SRCS})
target_include_directories(enet_lwip.axf PRIVATE ${EXAMPLE_INCLUDE_DIRS})
target_compile_options(enet_lwip.axf PRIVATE ${EXAMPLE_COMPILER_FLAGS} ${PLATFORM_COMPILER_FLAGS})
target_link_options(enet_lwip.axf PRIVATE ${PLATFORM_LINKER_FLAGS} -T${LINKER_SCRIPT} --entry ${ENTRY})
target_compile_definitions(enet_lwip.axf PRIVATE)
target_link_libraries(enet_lwip.axf 
    ${LWIP_SANITIZER_LIBS} 
    lwipcontribexamples 
    lwipcontribapps 
    lwipcontribaddons 
    lwipallapps 
    lwipcontribporttiva 
    lwipcore 
    lwipmbedtls 
    ${TIVAWARE_LIBRARY} 
    tivawaredriverlib
)

add_custom_command(TARGET enet_lwip.axf
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} ARGS -O binary enet_lwip.axf enet_lwip.bin)
