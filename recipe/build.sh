#!/bin/bash

export LDFLAGS="-lmpi -fopenmp $LDFLAGS"

BUILD_DIR=${SRC_DIR}/build
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}

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
-D PKG_OPT=yes \
-D PKG_NETCDF=yes \
-D PKG_OPENMP=yes \
-D PKG_MISC=yes \
-D PKG_MOLECULE=yes \
-D PKG_RIGID=yes \
-D CMAKE_INSTALL_PREFIX=${PREFIX} \
$SRC_DIR/cmake

make -j$(nproc)

make install
