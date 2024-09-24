#!/bin/bash
#Written by Jing Xiang CHUNG on 19/9/2024
#A script to compile all libraries needed by WRF, WPS and HRLDAS, since they do not work well with new JASPER and don't like new JASPER is in the same directory as other needed libraries.

#Getting everything ready------------------------
INSTALL_DIR=`pwd`
PATH_to_SRC='/home/jingxiang/My_Works/Research/MySrc'

export LD_LIBRARY_PATH=${INSTALL_DIR}/lib:${LD_LIBRARY_PATH}
export LDFLAGS="$LDFLAGS -L${INSTALL_DIR}/lib"
export CPPFLAGS="${CPPFLAGS} -I${INSTALL_DIR}/include"
export CFLAGS=-fPIC
export PATH=${INSTALL_DIR}/bin:${PATH}

#1. PNG---------------------------------------
#libpng-1.6.43: http://www.libpng.org/pub/png/libpng.html
echo "...compiling libpng..."
tar -xzvf ${PATH_to_SRC}/libpng-1.6.43.tar.gz; cd libpng-1.6.43;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#2. zlib-----------------------------------------
#zlib-1.3.1: https://github.com/madler/zlib/releases 
tar -xzvf ${PATH_to_SRC}/zlib-1.3.1.tar.gz; cd zlib-1.3.1;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#3. HDF5-----------------------------------------
#hdf5-1.14.4-3: https://github.com/HDFGroup/hdf5/releases
#Threadsafe+Unsupported to ensure cdo can chain nc4 data and high level libraries can be built, remove them if HDF5 breaks
echo "...compiling hdf5..."
tar -xzvf ${PATH_to_SRC}/hdf5-1.14.4-3.tar.gz; cd hdf5-1.14.4-3;./configure --prefix=${INSTALL_DIR} --enable-hl --enable-build-mode=production --with-pic --with-szlib=${INSTALL_DIR} --enable-threadsafe --enable-unsupported CFLAGS=-fPIC --enable-parallel;make;make install;cd ..

#4. NetCDF4(need HDF5)---------------------------
#netcdf-4.9.2: https://downloads.unidata.ucar.edu/netcdf/
echo "...compiling netcdf-c..."
tar -xzvf ${PATH_to_SRC}/netcdf-c-4.9.2.tar.gz; cd netcdf-c-4.9.2;./configure --prefix=${INSTALL_DIR} --enable-shared --enable-netcdf-4 --enable-hdf4 --enable-pnetcdf;make;make install;cd ..

#*NetCDF4(extra)---------------
#netcdf-cxx4-4.3.1
echo "...compiling netcdf-cxx..."
tar -xzvf ${PATH_to_SRC}/netcdf-cxx4-4.3.1.tar.gz; cd netcdf-cxx4-4.3.1;./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install;cd ..

#netcdf-fortran-4.6.1
echo "...compiling netcdf-fortran..."
tar -xzvf ${PATH_to_SRC}/netcdf-fortran-4.6.1.tar.gz; cd netcdf-fortran-4.6.1;./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install;cd ..

#5. Jasper------------------------------------
echo "...compiling jasper..."
#jasper-1.900.29
tar -xzvf ${PATH_to_SRC}/jasper-1.900.29.tar.gz; cd jasper-1.900.29; ./configure --prefix=${INSTALL_DIR};make; make install; cd ..

echo "Job completed!"
