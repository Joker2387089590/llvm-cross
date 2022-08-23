export COMPILER_FLAGS="--target=armv7a-unknown-linux-musleabihf -mcpu=cortex-a9 -mfloat-abi=hard -mfpu=vfpv3-d16 --sysroot=${SYSROOT} -fuse-ld=lld -rtlib=compiler-rt -unwindlib=libunwind"

make \
ARCH=arm \
FREESTANDING=yes \
INCLUDEDIR=/include \
PKGCONFIGDIR=/lib/pkgconfig \
FORCE_SOFT_FLOAT=yes \
FORCE_HARD_FLOAT=yes \
CC=clang \
CXX=clang++ \
CPP=clang++ \
AR=llvm-ar \
CFLAGS="${COMPILER_FLAGS}" \
ASFLAGS="${COMPILER_FLAGS}" \
LDFLAGS="${COMPILER_FLAGS}"

# make \
# ARCH=arm \
# INCLUDEDIR=/include \
# PKGCONFIGDIR=/lib/pkgconfig \
# FORCE_SOFT_FLOAT=yes \
# FORCE_HARD_FLOAT=yes \
# CC=clang \
# CXX=clang++ \
# CPP=clang++ \
# AR=llvm-ar \
# CFLAGS="${COMPILER_FLAGS}" \
# ASFLAGS="${COMPILER_FLAGS}" \
# LDFLAGS="${COMPILER_FLAGS}" \
# check

make \
ARCH=arm \
INCLUDEDIR=/include \
PKGCONFIGDIR=/lib/pkgconfig \
FORCE_SOFT_FLOAT=yes \
FORCE_HARD_FLOAT=yes \
CC=clang \
CXX=clang++ \
CPP=clang++ \
AR=llvm-ar \
CFLAGS="${COMPILER_FLAGS}" \
ASFLAGS="${COMPILER_FLAGS}" \
LDFLAGS="${COMPILER_FLAGS}" \
DESTDIR=/home/joker/repo/llvm/install \
install
