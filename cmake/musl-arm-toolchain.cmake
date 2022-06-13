set(CMAKE_SYSTEM_NAME Linux) # CMAKE_CROSSCOMPILING is set to ON automatically by this.
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(MUSL_ARM_STATIC_TRY_COMPILE ON)
if(MUSL_ARM_STATIC_TRY_COMPILE)
    set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY) # magic option...
endif()

# set sysroot, get from environment
if(EXISTS $ENV{MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT} AND 
   IS_DIRECTORY $ENV{MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT})
    set(CMAKE_SYSROOT $ENV{MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT})
else()
    message(FATAL_ERROR "Environment variable 'MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT' is not set!")
endif()

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# set compiler as Clang
set(CMAKE_ASM_COMPILER /bin/clang)
set(CMAKE_C_COMPILER   /bin/clang)
set(CMAKE_CXX_COMPILER /bin/clang++)

# compiler target triple
set(CLANG_TARGET_TRIPLE "armv7a-unknown-linux-musleabihf")
set(CMAKE_ASM_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})
set(CMAKE_C_COMPILER_TARGET   ${CLANG_TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})

# use the custom built libc++
set(CMAKE_INCLUDE_DIRECTORIES_BEFORE OFF)
# include_directories(SYSTEM ${CMAKE_SYSROOT}/include)
include_directories(SYSTEM ${CMAKE_SYSROOT}/include/c++/v1)
# include_directories(SYSTEM ${CMAKE_SYSROOT}/usr/include) 
link_directories(${CMAKE_SYSROOT}/lib)

# add machine's search path
# include_directories(AFTER SYSTEM ${CMAKE_SYSROOT}/usr/include/arm-linux-gnueabihf)

set(CLANG_LINKER_FLAGS
    "-fuse-ld=lld -rtlib=compiler-rt -unwindlib=libunwind \
     -Wl,-rpath,${CMAKE_SYSROOT}/lib -lc++")
set(CLANG_COMPILER_FLAGS 
    "-mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard \
     -nostdlib++")

# add link flags to compile flags, will force clang use compiler-rt, but generate much warnings.
option(MUSL_ARM_FORCE_USE_COMPILER_RT OFF)
if(MUSL_ARM_FORCE_USE_COMPILER_RT)
    set(CLANG_COMPILER_FLAGS "${CLANG_COMPILER_FLAGS} ${CLANG_LINKER_FLAGS}")
endif()

# let CMake use -std=c++** instead of -std=gnu++**
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${CLANG_COMPILER_FLAGS}")
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${CLANG_COMPILER_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CLANG_COMPILER_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}    ${CLANG_LINKER_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${CLANG_LINKER_FLAGS}")
# set(CMAKE_STATIC_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS} ${CLANG_LINKER_FLAGS}")

if(MUSL_ARM_CHAINLOAD_TOOLCHAIN_FILE)
    include(${MUSL_ARM_CHAINLOAD_TOOLCHAIN_FILE})
endif()
