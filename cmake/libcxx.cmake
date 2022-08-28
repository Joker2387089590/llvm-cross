set(CMAKE_SYSTEM_NAME Linux) # CMAKE_CROSSCOMPILING is set to ON automatically by this.
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_ASM_COMPILER /bin/clang)
set(CMAKE_C_COMPILER   /bin/clang)
set(CMAKE_CXX_COMPILER /bin/clang++)

set(CLANG_TARGET_TRIPLE "arm-linux-musleabihf")
set(CMAKE_ASM_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})
set(CMAKE_C_COMPILER_TARGET   ${CLANG_TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})

set(CLANG_TARGET_FLAGS 
    "-mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard \
     -nostdlib -nostdinc \
     -isystem/home/joker/repo/llvm-cross/root/usr/arm-linux-musleabihf/include\
     -isystem/home/joker/repo/llvm-cross/root/usr/include")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${CLANG_TARGET_FLAGS}")
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${CLANG_TARGET_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CLANG_TARGET_FLAGS}")

set(CLANG_LINKER_FLAGS 
    "-fuse-ld=lld -L ${CMAKE_SYSROOT}/usr/${CLANG_TARGET_TRIPLE}/lib")
set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}    ${CLANG_LINKER_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${CLANG_LINKER_FLAGS}")

# set(CMAKE_REQUIRED_INCLUDES $ENV{SYSROOT}/usr/include ${CMAKE_SYSROOT}/include)
# set(CMAKE_REQUIRED_FLAGS ${CLANG_TARGET_FLAGS})
# set(CMAKE_REQUIRED_LINK_OPTIONS ${CLANG_LINKER_FLAGS})
