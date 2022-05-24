export SYSROOT=/mnt/sglib
mkdir -p usr/local/include
mkdir -p usr/local/lib
ln -s usr/local/include include
ln -s usr/local/lib lib
ln -s $SYSROOT/usr/include usr/include
ln -s $SYSROOT/usr/lib usr/lib
