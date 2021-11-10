cmake_minimum_required(VERSION 3.15)

set(projectName libp11)
project(
  ${projectName}
  VERSION 0.4.11
  # DESCRIPTION "PKCS#11 wrapper library" HOMEPAGE
  # "https://github.com/OpenSC/libp11"
  LANGUAGES C)

find_package(OpenSSL REQUIRED)
find_package(Threads REQUIRED)

configure_file(src/config.h.cmake.in ${CMAKE_CURRENT_SOURCE_DIR}/src/config.h)

include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckSymbolExists)
set(AC_APPLE_UNIVERSAL_BUILD)
set(DEFAULT_PKCS11_MODULE /usr/lib/p11-kit-proxy.so)
check_include_file(dlfcn.h HAVE_DLFCN_H)
check_include_file(errno.h HAVE_ERRNO_H)
check_include_file(fcntl.h HAVE_FCNTL_H)
check_include_file(getopt.h HAVE_GETOPT_H)
check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(locale.h HAVE_LOCALE_H)
check_include_file(malloc.h HAVE_MALLOC_H)
set(HAVE_PTHREAD CMAKE_USE_PTHREADS_INIT)
check_include_file(malloc.h HAVE_PTHREAD_PRIO_INHERIT)
check_symbol_exists(PTHREAD_PRIO_INHERIT pthread.h HAVE_PTHREAD_PRIO_INHERIT)
check_include_file(stdint.h HAVE_STDINT_H)
check_include_file(stdio.h HAVE_STDIO_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(string.h HAVE_STRING_H)
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(sys/time.h HAVE_SYS_TIME_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(sys/wait.h HAVE_SYS_WAIT_H)
check_include_file(unistd.h HAS_UNISTD_H)
check_include_file(utmp.h HAVE_UTMP_H)
set(LT_OBJDIR .libs/)
set(PACKAGE ${PROJECT_NAME})
set(PACKAGE_BUGREPORT)
set(PACKAGE_NAME ${PROJECT_NAME})
set(PACKAGE_STRING ${PROJECT_NAME} ${PROJECT_VERSION})
set(PACKAGE_TARNAME ${PROJECT_NAME})
set(PACKAGE_URL)
set(PACKAGE_VERSION ${PROJECT_VERSION})
set(PTHREAD_CREATE_JOINABLE)
CHECK_INCLUDE_FILES ("stdlib.h;stdarg.h;string.h;float.h" STDC_HEADERS)
set(USE_CYGWIN)
set(VERSION ${PROJECT_VERSION})

# --- libp11 ---

set(targetName libp11)
add_library(${targetName} SHARED "")
add_library(${projectName}::${targetName} ALIAS ${targetName})

set(${targetName}ExportHeaderList src/libp11.h src/p11_err.h)
set(${targetName}Resources src/libp11.rc)
set(${targetName}Sources
    src/libpkcs11.c
    src/p11_attr.c
    src/p11_cert.c
    src/p11_err.c
    src/p11_ckr.c
    src/p11_key.c
    src/p11_load.c
    src/p11_misc.c
    src/p11_rsa.c
    src/p11_ec.c
    src/p11_pkey.c
    src/p11_slot.c
    src/p11_front.c
    src/p11_atfork.c)

target_sources(
  ${targetName} PRIVATE ${${targetName}Resources} ${${targetName}Sources}
                        ${${targetName}ExportHeaderList})

target_link_libraries(${targetName} PRIVATE OpenSSL::Crypto)

if(WIN32)
target_compile_definitions(${targetName} PRIVATE _WIN32_WINNT=0x0600)
endif()

if(HAS_UNISTD_H)
  target_compile_definitions(${targetName} PRIVATE HAS_UNISTD_H)
endif()

# --- pkcs11 ---

set(targetName pkcs11)
add_library(${targetName} SHARED "")
add_library(${projectName}::${targetName} ALIAS ${targetName})

set(${targetName}ExportHeaderList src/pkcs11.h)
set(${targetName}Resources src/pkcs11.rc)
set(${targetName}Sources src/eng_front.c src/eng_back.c src/eng_parse.c
                         src/eng_err.c)

target_sources(
  ${targetName} PRIVATE ${${targetName}Resources} ${${targetName}Sources}
                        ${${targetName}ExportHeaderList})

target_link_libraries(${targetName} PRIVATE OpenSSL::Crypto)

if(WIN32)
target_compile_definitions(${targetName} PRIVATE _WIN32_WINNT=0x0600)
endif()

# --- examples ---

set(EXAMPLES auth decrypt getrandom listkeys)
foreach(ex ${EXAMPLES})
  add_executable(${ex} examples/${ex}.c)
  target_include_directories(${ex} PRIVATE src)
  target_link_libraries(${ex} PRIVATE libp11)
  target_link_libraries(${ex} PRIVATE OpenSSL::Crypto)
endforeach()

#include(GNUInstallDirs)
install(TARGETS libp11)
# install(TARGETS pkcs11)
install(TARGETS ${EXAMPLES})

message("

libp11 has been configured with the following options:

Version:                 ${PROJECT_VERSION}
libp11 directory:        ${libdir}
Engine directory:        ${enginesexecdir}
Default PKCS11 module:   ${pkcs11_module}
API doc support:         ${enable_api_doc}

Host:                    ${CMAKE_HOST_SYSTEM_NAME} 
Compiler:                ${CMAKE_C_COMPILER}
Preprocessor flags:      ${CMAKE_CPPFLAGS}
Compiler flags:          ${CMAKE_C_FLAGS}
Linker flags:            ${CMAKE_SHARED_LINKER_FLAGS}
Libraries:               ${LIBS}

OPENSSL_CFLAGS:          ${OPENSSL_CFLAGS}
OPENSSL_LIBS:            ${OPENSSL_LIBS}

")