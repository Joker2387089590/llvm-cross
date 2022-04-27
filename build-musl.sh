export SYSROOT=/home/joker/repo/llvm/install

export COMPILER_FLAGS="--target=armv7a-unknown-linux-musleabihf -mcpu=cortex-a9 -mfloat-abi=hard -mfpu=vfpv3-d16 --sysroot=${SYSROOT}"

../musl-1.2.3/configure \
--prefix=${SYSROOT} \
--target=armv7a-unknown-linux-musleabihf \
--syslibdir=/home/joker/repo/llvm/install/lib \
ARCH=arm \
CC=clang \
CXX=clang++ \
CFLAGS="${COMPILER_FLAGS}" \
CXXFLAGS="${COMPILER_FLAGS}" \
LDFLAGS="-fuse-ld=lld -rtlib=compiler-rt -flto=thin -unwindlib=none" \
DESTDIR=${SYSROOT} \
LIBCC=/usr/lib/clang/14.0.1/lib/linux/libclang_rt.builtins-armhf.a \
CROSS_COMPILE=llvm- # check config.mak!!!
