# export SRCROOT=/home/joker/repo/llvm-cross
# export SRCROOT=/home/joker/repo/llvm
# export SYSROOT=$SRCROOT/root

build-llvm () {
    case $1 in
    linux | compiler-rt | musl | libucontext | libcxx | qt | lldb-server)
        mkdir -p arm-build/$1 && cd arm-build/$1
        rm CMakeCache.txt
        $SRCROOT/scripts/build-$1.sh
        cmake --build .
        cd -
    ;;
    esac
}
