cmake $SRCROOT/llvm-project/runtimes                                    \
-G Ninja                                                                \
-D CMAKE_SYSROOT=$SYSROOT                                               \
-D CMAKE_INSTALL_PREFIX=$SYSROOT                                        \
-D CMAKE_TOOLCHAIN_FILE=$SRCROOT/cmake/libcxx.cmake                     \
-D LLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind"        \
-D LLVM_CONFIG_PATH=/usr/bin/llvm-config                                \
-D COMPILER_RT_USE_BUILTINS_LIBRARY=ON                                  \
-D LIBUNWIND_USE_COMPILER_RT=ON                                         \
-D LIBCXXABI_USE_LLVM_UNWINDER=ON                                       \
-D LIBCXXABI_USE_COMPILER_RT=ON                                         \
-D LIBCXXABI_ENABLE_THREADS=ON                                          \
-D LIBCXX_CXX_ABI=libcxxabi                                             \
-D LIBCXX_USE_COMPILER_RT=ON                                            \
-D LIBCXX_HAS_MUSL_LIBC=ON                                              \


# cmake --build . -j
# cmake --install . -v --prefix=$SYSROOT/usr/arm-linux-musleabihf

# Bugs made by cmake 'check_library_exists':
#   When cmake runs try_compile, it uses the libraries on host path.
#   Once we are cross-compiling, the CMAKE_SYSROOT is no effect on it.
# This led some flags of llvm are wrong to select its options to compile.
#
# In order to avoid it, we should set llvm's cmake options below manually:
#
# 1. musl has no '__cxa_thread_atexit_impl', it is an extension of glibc.
#     -D LIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=FALSE
# 2. libc++ will always use libatomic when it was found.
#     -D LIBCXX_HAS_ATOMIC_LIB=FALSE

# set(CMAKE_SIZEOF_VOID_P 4)


# -D COMPILER_RT_BUILD_BUILTINS=ON \
# -D COMPILER_RT_BUILD_LIBFUZZER=OFF \
# -D COMPILER_RT_BUILD_MEMPROF=OFF \
# -D COMPILER_RT_BUILD_PROFILE=OFF \
# -D COMPILER_RT_BUILD_SANITIZERS=OFF \
# -D COMPILER_RT_BUILD_XRAY=OFF \
# -D COMPILER_RT_BUILD_ORC=OFF \
