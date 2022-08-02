export COMPILER_FLAGS="--target=armv7a-unknown-linux-musleabihf -mcpu=cortex-a9 -mfloat-abi=hard -mfpu=vfpv3-d16 --sysroot=${SYSROOT}"

$SRCROOT/musl/configure \
--prefix=/usr \
--includedir=/usr/include/arm-linux-musleabihf \
--libdir=/usr/lib/arm-linux-musleabihf \
--target=armv7a-unknown-linux-musleabihf \
ARCH=arm \
CC=clang \
CXX=clang++ \
CFLAGS="$COMPILER_FLAGS" \
CXXFLAGS="$COMPILER_FLAGS" \
LDFLAGS="-fuse-ld=lld -rtlib=compiler-rt -unwindlib=none" \
DESTDIR=$SYSROOT \
LIBCC=/usr/lib/clang/$(llvm-config --version)/lib/linux/libclang_rt.builtins-armhf.a \
CROSS_COMPILE=llvm- # check config.mak!!!

# make
# make DESTDIR=/home/joker/repo/llvm/root install