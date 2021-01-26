#!/bin/bash

BUILD_DIR=${SRC_DIR}/build
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}

# MOLFILE_INCLUDE_DIR=$PREFIX/lib/plugins/include
# if [ ! -d $MOLFILE_INCLUDE_DIR ]; then
#     exit 1
# fi
# MOLFILE_PLUGINS_DIR=$PREFIX/lib/plugins/LINUXAMD64/molfile/
# if [ ! -e $MOLFILE_PLUGINS_DIR ]; then
#     exit 1
# fi
# cp -r $MOLFILE_PLUGINS_DIR $PREFIX/lib/molfile
# -D PKG_USER-MOLFILE=yes \
# -D MOLFILE_INCLUDE_DIR="$MOLFILE_INCLUDE_DIR" \

BUILD_DIR=${SRC_DIR}/build
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}

CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")

cmake \
-D BUILD_MPI=yes \
-D BUILD_OMP=yes \
-D PKG_PYTHON=on \
-D BUILD_SHARED_LIBS=on \
-D LAMMPS_EXCEPTIONS=yes \
-D WITH_JPEG=no \
-D WITH_PNG=yes \
-D WITH_FFMPEG=no \
-D WITH_GZIP=no \
-D PKG_USER-OMP=yes \
-D PKG_OPT=yes \
-D PKG_USER-NETCDF=yes \
-D PKG_MISC=yes \
-D PKG_USER-MISC=yes \
-D PKG_MOLECULE=yes \
-D PKG_RIGID=yes \
-D CMAKE_INSTALL_PREFIX=${PREFIX} \
${CMAKE_PLATFORM_FLAGS[@]} \
$SRC_DIR/cmake

make -j$(nproc)

make install