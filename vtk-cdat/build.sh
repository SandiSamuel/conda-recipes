#!/bin/bash

mkdir build
cd build

CONDA_LST=`conda list`
if [[ ${CONDA_LST}'y' == *'openmpi'* ]]; then
    export CC=mpicc
    export CXX=mpicxx
    export LC_RPATH="${PREFIX}/lib"
    export DYLD_FALLBACK_LIBRARY_PATH=${PREFIX}/lib
    MPI_ARGS="-DVTK_USE_MPI:BOOL=ON"
else
    if [ `uname` == Linux ]; then
        # To make sure we get the correct g++
        export LD_LIBRARY_PATH=${PREFIX}/lib:${LIBRARY_PATH}
        export CC="gcc -Wl,-rpath=${PREFIX}/lib"
        export CXX="g++ -Wl,-rpath=${PREFIX}/lib"
    else
        export CC="gcc"
        export CXX="g++"
    fi
    MPI_ARGS=""
fi


if [ `uname` == Linux ]; then
    PY_LIB="libpython${PY_VER}.so"
elif [ `uname` == Darwin ]; then
    PY_LIB="libpython${PY_VER}.dylib"
fi

COMMON_ARGS="-DCMAKE_C_COMPILER=$CC \
        -DCMAKE_CXX_COMPILER=$CXX \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_INSTALL_PREFIX=\"${PREFIX}\" \
        -DCMAKE_INSTALL_RPATH:STRING=\"${PREFIX}/lib\" \
        -DBUILD_DOCUMENTATION=OFF \
        -DBUILD_TESTING:BOOL=OFF \
        -DVTK_HAS_FEENABLEEXCEPT=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DModule_vtkCommonComputationalGeometry:BOOL=ON \
        -DModule_vtkCommonCore:BOOL=ON \
        -DModule_vtkCommonExecutionModel:BOOL=ON \
        -DModule_vtkCommonMisc:BOOL=ON \
        -DModule_vtkCommonSystem:BOOL=ON \
        -DModule_vtkCommonTransforms:BOOL=ON \
        -DModule_vtkFiltersAMR:BOOL=ON \
        -DModule_vtkFiltersCore:BOOL=ON \
        -DModule_vtkFiltersExtraction:BOOL=ON \
        -DModule_vtkFiltersFlowPaths:BOOL=ON \
        -DModule_vtkFiltersGeneral:BOOL=ON \
        -DModule_vtkFiltersGeneric:BOOL=ON \
        -DModule_vtkFiltersGeometry:BOOL=ON \
        -DModule_vtkFiltersHybrid:BOOL=ON \
        -DModule_vtkFiltersImaging:BOOL=ON \
        -DModule_vtkFiltersModeling:BOOL=ON \
        -DModule_vtkFiltersSelection:BOOL=ON \
        -DModule_vtkFiltersSMP:BOOL=ON \
        -DModule_vtkFiltersSources:BOOL=ON \
        -DModule_vtkFiltersStatistics:BOOL=ON \
        -DModule_vtkFiltersTexture:BOOL=ON \
        -DModule_vtkGeovisCore:BOOL=ON \
        -DModule_vtkImagingColor:BOOL=ON \
        -DModule_vtkImagingCore:BOOL=ON \
        -DModule_vtkImagingGeneral:BOOL=ON \
        -DModule_vtkImagingMath:BOOL=ON \
        -DModule_vtkImagingSources:BOOL=ON \
        -DModule_vtkImagingStencil:BOOL=ON \
        -DModule_vtkInteractionImage:BOOL=ON \
        -DModule_vtkInteractionStyle:BOOL=ON \
        -DModule_vtkInteractionWidgets:BOOL=ON \
        -DModule_vtkIOCore:BOOL=ON \
        -DModule_vtkIOExport:BOOL=ON \
        -DModule_vtkIOExportOpenGL:BOOL=ON \
        -DModule_vtkIOGeometry:BOOL=ON \
        -DModule_vtkIOImage:BOOL=ON \
        -DModule_vtkIOImport:BOOL=ON \
        -DModule_vtkRenderingCore:BOOL=ON \
        -DModule_vtkRenderingFreeType:BOOL=ON \
        -DModule_vtkRenderingFreeTypeOpenGL:BOOL=ON \
        -DModule_vtkRenderingImage:BOOL=ON \
        -DModule_vtkRenderingLabel:BOOL=ON \
        -DModule_vtkRenderingOpenGL:BOOL=ON \
        -DModule_vtkRenderingVolume:BOOL=ON \
        -DModule_vtkRenderingVolumeOpenGL:BOOL=ON \
        -DModule_vtkViewsCore:BOOL=ON \
        -DModule_vtkViewsGeovis:BOOL=ON \
        -DModule_vtkIOFFMPEG:BOOL=ON \
        -DBUILD_SHARED_LIBS=ON \
        -DVTK_WRAP_PYTHON=ON \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_INCLUDE_PATH=${PREFIX}/include/python${PY_VER} \
        -DPYTHON_LIBRARY=${PREFIX}/lib/${PY_LIB} \
        -DVTK_INSTALL_PYTHON_MODULE_DIR=${SP_DIR} \
        -DModule_vtkRenderingMatplotlib=ON \
        -DVTK_Group_Web:BOOL=ON \
        -DLIBPROJ4_INCLUDE_DIR:PATH=${PREFIX}/include \
        -DVTK_RENDERING_BACKEND=OpenGL \
        -DVTK_USE_SYSTEM_ZLIB:BOOL=ON \
        -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON \
        -DVTK_USE_SYSTEM_HDF5:BOOL=ON \
        -DVTK_USE_SYSTEM_NETCDF:BOOL=ON \
        -DVTK_USE_SYSTEM_FREETYPE:BOOL=OFF \
        -DVTK_USE_SYSTEM_LIBPROJ4:BOOL=ON \
        -DVTK_Group_Rendering:BOOL=ON \
        -DVTK_Group_StandAlone:BOOL=OFF \
        -DVTK_LEGACY_SILENT:BOOL=ON"


if [ `uname` == Linux ]; then

    if [[ ${CONDA_LST}'y' == *'mesalib'* ]]; then
        COMMAND="cmake .. -DVTK_USE_X:BOOL=OFF -DVTK_OPENGL_HAS_OSMESA:BOOL=ON -DOPENGL_INCLUDE_DIR:PATH=${PREFIX}/include -DOPENGL_gl_LIBRARY:FILEPATH=${PREFIX}/lib/libOSMesa.so -DOPENGL_glu_LIBRARY:FILEPATH=${PREFIX}/lib/libGLU.so -DOSMESA_INCLUDE_DIR:PATH=${PREFIX}/include -DOSMESA_LIBRARY:FILEPATH=${PREFIX}/lib/libOSMesa32.so -DLIBPROJ4_LIBRARIES:FILEPATH=${PREFIX}/lib/libproj.so \
              ${MPI_ARGS} \
              ${COMMON_ARGS}"
        eval ${COMMAND}
    else
        COMMAND="cmake .. -DVTK_USE_X:BOOL=ON  -DLIBPROJ4_LIBRARIES:FILEPATH=${PREFIX}/lib/libproj.so \
              ${MPI_ARGS} \
              ${COMMON_ARGS}"
        eval ${COMMAND}
    fi
fi

if [ `uname` == Darwin ]; then
    COMMAND="cmake .. \
        -DVTK_REQUIRED_OBJCXX_FLAGS='' \
        -DVTK_USE_CARBON=OFF \
        -DVTK_USE_COCOA=ON \
        -DVTK_USE_X=OFF \
        -DLIBPROJ4_LIBRARIES:FILEPATH=${PREFIX}/lib/libproj.dylib \
        -DCMAKE_OSX_DEPLOYMENT_TARGET=10.12 \
        ${MPI_ARGS} \
        ${COMMON_ARGS}"
    eval ${COMMAND}
fi

make -j7
make install
