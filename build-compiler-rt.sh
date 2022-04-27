export SYSROOT=/home/joker/repo/llvm/install
export CLANG_TARGET_TRIPLE="armv7a-unknown-linux-musleabihf"
export CLANG_TARGET_FLAGS="-march=armv7a -mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard --target=armv7a-unknown-linux-musleabihf"

cmake ~/repo/llvm/llvm-project/compiler-rt \
-G Ninja \
-D CMAKE_ASM_COMPILER=clang \
-D CMAKE_C_COMPILER=clang \
-D CMAKE_CXX_COMPILER=clang++ \
-D CMAKE_ASM_COMPILER_TARGET=${CLANG_TARGET_TRIPLE} \
-D CMAKE_C_COMPILER_TARGET=${CLANG_TARGET_TRIPLE} \
-D CMAKE_CXX_COMPILER_TARGET=${CLANG_TARGET_TRIPLE} \
-D CMAKE_ASM_FLAGS="-march=armv7a -mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard -ffreestanding -nostdlib -nostdlib++" \
-D CMAKE_C_FLAGS="-march=armv7a -mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard -ffreestanding -nostdlib -nostdlib++" \
-D CMAKE_CXX_FLAGS="-march=armv7a -mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard -ffreestanding -nostdlib -nostdlib++" \
-D CMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \
-D CMAKE_SYSROOT=${SYSROOT} \
-D CMAKE_INSTALL_PREFIX="/usr/lib/clang/14.0.1" \
-D COMPILER_RT_USE_BUILTINS_LIBRARY=ON \
-D COMPILER_RT_BUILD_BUILTINS=ON \
-D COMPILER_RT_BUILD_LIBFUZZER=OFF \
-D COMPILER_RT_BUILD_MEMPROF=OFF \
-D COMPILER_RT_BUILD_PROFILE=OFF \
-D COMPILER_RT_BUILD_SANITIZERS=OFF \
-D COMPILER_RT_BUILD_XRAY=OFF \
-D COMPILER_RT_DEFAULT_TARGET_ONLY=ON \
-D COMPILER_RT_INCLUDE_TESTS=OFF \
-D COMPILER_RT_BUILD_CRT=ON \
-D COMPILER_RT_BUILD_ORC=OFF \
-D CMAKE_SIZEOF_VOID_P=4

# cmake --build .
# cmake --install . -v --prefix ../install

# -D COMPILER_RT_BUILD_BUILTINS=ON
# -D COMPILER_RT_BUILD_LIBFUZZER=OFF
# -D COMPILER_RT_BUILD_MEMPROF=OFF
# -D COMPILER_RT_BUILD_PROFILE=OFF
# -D COMPILER_RT_BUILD_SANITIZERS=OFF
# -D COMPILER_RT_BUILD_XRAY=OFF
# -D COMPILER_RT_DEFAULT_TARGET_ONLY=ON
