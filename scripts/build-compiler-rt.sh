export CLANG_TARGET_TRIPLE=arm-linux-musleabihf
export CLANG_TARGET_FLAGS="-mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard -isystem${SYSROOT}/usr/${CLANG_TARGET_TRIPLE}/include -isystem${SYSROOT}/usr/include -nostdlib -nostdinc"

cmake $SRCROOT/llvm-project/runtimes                             \
-G Ninja                                                         \
-D CMAKE_INSTALL_PREFIX=/usr/lib/clang/$(llvm-config --version)  \
-D LLVM_ENABLE_RUNTIMES="compiler-rt"                            \
-D LLVM_CONFIG_PATH=/bin/llvm-config                             \
-D CMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY                  \
-D CMAKE_ASM_COMPILER=/bin/clang                                 \
-D CMAKE_C_COMPILER=/bin/clang                                   \
-D CMAKE_AR=/bin/llvm-ar                                         \
-D CMAKE_NM=/bin/llvm-nm                                         \
-D CMAKE_RANLIB=/bin/llvm-ranlib                                 \
-D CMAKE_ASM_COMPILER_TARGET="${CLANG_TARGET_TRIPLE}"            \
-D CMAKE_C_COMPILER_TARGET="${CLANG_TARGET_TRIPLE}"              \
-D CMAKE_ASM_FLAGS="${CLANG_TARGET_FLAGS}"                       \
-D CMAKE_C_FLAGS="${CLANG_TARGET_FLAGS}"                         \
-D CMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld"                         \
-D COMPILER_RT_DEFAULT_TARGET_ONLY=ON                            \
-D COMPILER_RT_BUILD_BUILTINS=ON                                 \
-D COMPILER_RT_BUILD_LIBFUZZER=OFF                               \
-D COMPILER_RT_BUILD_MEMPROF=OFF                                 \
-D COMPILER_RT_BUILD_SANITIZERS=OFF                              \
-D COMPILER_RT_BUILD_XRAY=OFF                                    \
-D COMPILER_RT_BUILD_PROFILE=OFF                                 \
-D CMAKE_SIZEOF_VOID_P=4                                         \
