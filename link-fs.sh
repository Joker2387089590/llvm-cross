export SYSROOT=/mnt/sglib
mkdir -p usr/local

ln -s $SYSROOT/include include
ln -s $SYSROOT/lib lib
ln -s $SYSROOT/usr/include usr/include
ln -s $SYSROOT/usr/lib usr/lib
