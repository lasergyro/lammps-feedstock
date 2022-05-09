#!/bin/bash

function feature()
{
    if [[ $1 == "1" ]]
    then
        echo "$2"
		return
	fi
	if [[ $1 == "0" ]]
	then
        echo "$3"
		return
    fi
}
if [[ $FEATURE_OPENMPI == "1" ]] && [[ $FEATURE_MPICH == "1" ]]
then echo "choose only one MPI implementation"; exit 1; fi

if [[ $FEATURE_OPENMPI == "1" ]] || [[ $FEATURE_MPICH == "1" ]]
then FEATURE_MPI="1"
else FEATURE_MPI="0"
fi



if [[ $FEATURE_MPI == "1" ]] then
	LDFLAGS=" -lmpi $LDFLAGS"
fi

if [[ $FEATURE_OPENMP == "1" ]] then
	LDFLAGS=" -fopenmp $LDFLAGS"
fi

export LDFLAGS

BUILD_DIR=${SRC_DIR}/build
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}" || (echo "can't move to build directory" ; exit 1)

cmake \
-D BUILD_MPI=$( feature $FEATURE_MPI yes no ) \
-D BUILD_OMP=$( feature $FEATURE_OPENMP yes no ) \
-D PKG_PYTHON=on \
-D BUILD_SHARED_LIBS=on \
-D LAMMPS_EXCEPTIONS=yes \
-D WITH_JPEG=no \
-D WITH_PNG=yes \
-D WITH_FFMPEG=no \
-D WITH_GZIP=no \
-D PKG_OPT=$( feature $FEATURE_OPT yes no ) \
-D PKG_NETCDF=$( feature $FEATURE_NETCDF yes no ) \
-D PKG_EXTRA-PAIR=$( feature $FEATURE_EXTRA_PAIR yes no ) \
-D PKG_OPENMP=yes \
-D PKG_MISC=yes \
-D PKG_MOLECULE=yes \
-D PKG_RIGID=yes \
-D CMAKE_INSTALL_PREFIX="${PREFIX}" \
"$SRC_DIR"/cmake

make -j$(nproc)

make install