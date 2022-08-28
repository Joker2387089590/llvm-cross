export CLANG_TARGET="arm-linux-musleabihf"
export CLANG_TARGET_FLAGS="-mcpu=cortex-a9 -mfloat-abi=hard -mfpu=vfpv3-d16"
export CLANG_LINKER_FLAGS="-fuse-ld=lld -rtlib=compiler-rt -unwindlib=none"
export COMPILER_FLAGS="--target=$CLANG_TARGET --sysroot=$SYSROOT $CLANG_TARGET_FLAGS"

$SRCROOT/musl/configure \
--prefix=/usr/arm-linux-musleabihf \
--target=arm-linux-musleabihf \
ARCH=arm \
CC=clang \
CROSS_COMPILE=llvm- \
CFLAGS="$COMPILER_FLAGS" \
LDFLAGS="$CLANG_LINKER_FLAGS" \
LIBCC=/usr/lib/clang/$(llvm-config --version)/lib/linux/libclang_rt.builtins-armhf.a

# make
# make DESTDIR=$SRCROOT/root install
