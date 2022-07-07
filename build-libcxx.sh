cmake $SRCROOT/llvm-project/runtimes \
-G Ninja \
-D CMAKE_SYSROOT=$SYSROOT \
-D CMAKE_INSTALL_PREFIX=$SYSROOT/usr/arm-linux-musleabihf \
-D CMAKE_TOOLCHAIN_FILE=$SRCROOT/cmake/libcxx.cmake \
-D LLVM_ENABLE_RUNTIMES="libunwind;libcxxabi;libcxx" \
-D LIBUNWIND_USE_COMPILER_RT=ON \
-D LIBCXXABI_USE_LLVM_UNWINDER=ON \
-D LIBCXXABI_USE_COMPILER_RT=ON \
-D LIBCXXABI_ENABLE_THREADS=ON \
-D LIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=FALSE \
-D LIBCXX_CXX_ABI=libcxxabi \
-D LIBCXX_USE_COMPILER_RT=ON \
-D LIBCXX_HAS_ATOMIC_LIB=FALSE \
-D LIBCXX_HAS_MUSL_LIBC=TRUE

# -D CMAKE_SIZEOF_VOID_P=4

# -D CMAKE_FIND_ROOT_PATH=${SYSROOT} \

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
