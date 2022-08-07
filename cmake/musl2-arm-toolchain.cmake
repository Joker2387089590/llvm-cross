option(MUSL_ARM_STATIC_TRY_COMPILE OFF)
option(MUSL_ARM_FORCE_USE_COMPILER_RT OFF)

### basic cmake options
set(CMAKE_SYSTEM_NAME Linux) # CMAKE_CROSSCOMPILING is set to ON automatically by this
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

### switch the try_compile mode, try this option when you meet errors during cmake configuring
if(MUSL_ARM_STATIC_TRY_COMPILE)
    set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY) # magic option...
endif()

### set sysroot, sysroot is required
if((EXISTS $ENV{MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT}) AND
   (IS_DIRECTORY $ENV{MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT}))
    # get from environment, your own CMAKE_SYSROOT may be discarded when compiling qt
    set(CMAKE_SYSROOT $ENV{MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT})
elseif(DEFINED CMAKE_SYSROOT)
    # set directly in command arguments
    message("CMAKE_SYSROOT: ${CMAKE_SYSROOT}")
else()
    message(FATAL_ERROR "No 'CMAKE_SYSROOT' is set! Or try to set environment variable 'MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT' if you have already set.")
endif()

### limit the search path of programs and libraries
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

### set compiler as Clang
set(CMAKE_ASM_COMPILER clang   CACHE FILEPATH)
set(CMAKE_C_COMPILER   clang   CACHE FILEPATH)
set(CMAKE_CXX_COMPILER clang++ CACHE FILEPATH)

### compiler target triple
set(CLANG_TARGET_TRIPLE "arm-linux-musleabihf")
set(CMAKE_ASM_COMPILER_TARGET ${CLANG_TARGET_TRIPLE} CACHE STRING)
set(CMAKE_C_COMPILER_TARGET   ${CLANG_TARGET_TRIPLE} CACHE STRING)
set(CMAKE_CXX_COMPILER_TARGET ${CLANG_TARGET_TRIPLE} CACHE STRING)

### use the custom built musl-libc and libc++
set(MUSL_ARM_CUSTOM_INCLUDE_DIR         ${CMAKE_SYSROOT}/usr/${CLANG_TARGET_TRIPLE}/include)
set(MUSL_ARM_CUSTOM_LIBCXX_INCLUDE_DIR  ${CMAKE_SYSROOT}/usr/${CLANG_TARGET_TRIPLE}/include/c++/v1)
set(MUSL_ARM_CUSTOM_LIB_DIR             ${CMAKE_SYSROOT}/usr/${CLANG_TARGET_TRIPLE}/lib)

# set include directories
#   Note: Headers from C++ standard library should be included after those from C standard library.
#   For example, 'signbit'(in math.h) is required to be a macro in C standard.
#   However, by writing another math.h as an overlay header, libc++ made it be a template,
#   and use 'include_next' to import C 'math.h' for compatiable.
set(MUSL_ARM_CUSTOM_INCLUDE_DIR         ${CMAKE_SYSROOT}/usr/${CLANG_TARGET_TRIPLE}/include)
set(MUSL_ARM_SYSTEM_INCLUDE_DIR         ${CMAKE_SYSROOT}/usr/include)
set(MUSL_ARM_CUSTOM_LIBCXX_INCLUDE_DIR  ${CMAKE_SYSROOT}/usr/${CLANG_TARGET_TRIPLE}/include/c++/v1)
set(CLANG_COMPILER_FLAGS 
    "${CLANG_COMPILER_FLAGS} \
    -isystem${MUSL_ARM_CUSTOM_INCLUDE_DIR} \
    -isystem${MUSL_ARM_SYSTEM_INCLUDE_DIR} \
    -isystem${MUSL_ARM_CUSTOM_LIBCXX_INCLUDE_DIR}")

# indicate clang to use llvm's components when linking
set(CLANG_LINKER_FLAGS
    "-L ${MUSL_ARM_CUSTOM_LIB_DIR} -lc++ \
     -fuse-ld=lld -rtlib=compiler-rt -unwindlib=libunwind")
# -Wl,-rpath,${MUSL_ARM_CUSTOM_LIB_DIR} 

# append link flags to compile flags
if(MUSL_ARM_FORCE_USE_COMPILER_RT)
    # this will force clang to use compiler-rt, but may generate too many warnings.
    set(CLANG_COMPILER_FLAGS "${CLANG_COMPILER_FLAGS} ${CLANG_LINKER_FLAGS}")
endif()

### compiler flags

# let CMake use -std=c++** instead of -std=gnu++**
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${CLANG_COMPILER_FLAGS}")
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${CLANG_COMPILER_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CLANG_COMPILER_FLAGS}")

# linker flags
set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}    ${CLANG_LINKER_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${CLANG_LINKER_FLAGS}")

### add addition toolchain
if(MUSL_ARM_CHAINLOAD_TOOLCHAIN_FILE)
    include(${MUSL_ARM_CHAINLOAD_TOOLCHAIN_FILE})
endif()
