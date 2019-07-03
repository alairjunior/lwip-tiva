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

