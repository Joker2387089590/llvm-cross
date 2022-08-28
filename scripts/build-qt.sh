export SYSROOT=$SRCROOT/root/usr/arm-linux-musleabihf
export QT_DIR=/opt/Qt/6.3.0
export TSLIB_INSTALL_DIR=/home/joker/repo/tslib/install

if  echo "QT_DIR: $QT_DIR"   &&
    [ -d $QT_DIR ]           &&
    echo "SYSROOT: $SYSROOT" &&
    [ -d $SYSROOT ]
then
    echo "Start configure Qt..."
else
    echo "ERROR!!!"
fi

export QT_HOST_PATH=$QT_DIR/gcc_64
export QT_TARGET_PATH=$QT_DIR/arm
export QT_SOURCE_DIR=$QT_DIR/Src
export MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT=$SYSROOT


$QT_SOURCE_DIR/configure \
-cmake-generator Ninja \
-prefix $QT_TARGET_PATH \
-extprefix $QT_TARGET_PATH \
-qt-host-path $QT_HOST_PATH \
-c++std c++20 \
-linker lld \
-sysroot $SYSROOT \
-submodules qt5compat,qtbase,qtserialport \
-skip qt3d,qtcharts,qtimageformats,qtactiveqt,qtcanvas3d,qtcoap,qtconnectivity,qtdatavis3d,qtdeclarative,qtdoc,qtfeedback,qtgamepad,qtlanguageserver,qtlocation,qtlottie,qtmqtt,qtmultimedia,qtnetworkauth,qtopcua,qtpim,qtpositioning,qtqa,qtquick3d,qtquicktimeline,qtremoteobjects,qtrepotools,qtscxml,qtsensors,qtserialbus,qtshadertools,qtspeech,qtsvg,qtsystems,qttools,qttranslations,qtvirtualkeyboard,qtwebchannel,qtwebengine,qtwebglplugin,qtwebsockets,qtwebview,qtxmlpatterns \
--sqlite=qt \
--zlib=qt \
--doubleconversion=qt \
-no-opengl \
-tslib \
-linuxfb \
-- \
-DCMAKE_PREFIX_PATH="$TSLIB_INSTALL_DIR" \
-DCMAKE_SYSROOT=$SYSROOT \
-DCMAKE_TOOLCHAIN_FILE=$SRCROOT/cmake/qt.cmake \
-DMUSL_ARM_FORCE_USE_COMPILER_RT=ON \
-DQT_BUILD_EXAMPLES=OFF \
-DQT_BUILD_TESTS=OFF \
-DQT_BUILD_TOOLS=OFF \
-Wno-dev
