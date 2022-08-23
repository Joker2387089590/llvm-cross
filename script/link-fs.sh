export SYSROOT=$SRCROOT/root
mkdir -p $SYSROOT/usr/arm-linux-musleabihf
mkdir -p $SYSROOT/usr/include/arm-linux-musleabihf
mkdir -p $SYSROOT/usr/lib/arm-linux-musleabihf

cd $SYSROOT/usr/arm-linux-musleabihf
ln -s ../include/arm-linux-musleabihf include
ln -s ../lib/arm-linux-musleabihf lib
