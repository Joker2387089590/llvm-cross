export SRCROOT=/home/joker/repo/llvm
export SYSROOT=/home/joker/repo/llvm/arm-install
mkdir -p arm-build/compiler-rt arm-build/libcxx arm-install

cd arm-install
../link-fs.sh
cd -

cd arm-build/musl
../../build-musl.sh
read -p "musl is configured, install headers?"
make install-headers
cd -

cd arm-build/compiler-rt
../../build-compiler-rt.sh
read -p "compiler-rt is built, install?"
sudo cmake --install . -v
cd -

cd arm-build/musl
make -j17
read -p "musl is built, install?"
make install
cd -

# rm -r arm-build/libucontext
# cp libucontext arm-build/libucontext
# cd arm-build/libucontext
# ../../build-libucontext
# read -p "libucontext built"
# cd -

cd arm-build/libcxx
../../build-libcxx.sh
read -p "libcxx is built, install?"
cmake --install . -v --prefix=$SYSROOT/usr/local
cd -

cd arm-install
tree -AC .

