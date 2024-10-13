#!/bin/bash
#Written by Jing Xiang CHUNG on 12/10/2024
#A script to compile all libraries frequently used by our research on acroporaC.

#Getting everything ready------------------------
INSTALL_DIR='/home/jxchung/software/JX_compiled'
INSTALL_DIR_GCC='/home/jxchung/software/JX_compiled_gcc'

export LD_LIBRARY_PATH=${INSTALL_DIR}/lib:${LD_LIBRARY_PATH}
export LDFLAGS="$LDFLAGS -L${INSTALL_DIR}/lib"
export CPPFLAGS="${CPPFLAGS} -I${INSTALL_DIR}/include"
export CFLAGS=-fPIC
export PATH=${INSTALL_DIR}/bin:${PATH}

#0. GCC------------------------------------------
echo "...compiling gcc..."
tar -xzf gcc-11.5.0.tar.gz; cd gcc-11.5.0;sed -i "s:='wget:='wget --no-check-certificate:g" contrib/download_prerequisites;./contrib/download_prerequisites;./configure --prefix=${INSTALL_DIR_GCC} --disable-multilib --enable-host-shared; make; make install;cd ..

#1. Zlib-----------------------------------------
#zlib-1.3.1.tar.gz: https://zlib.net/
echo "...compiling zlib..."
tar -xzf zlib-1.3.1.tar.gz; cd zlib-1.3.1.tar.gz;./configure --prefix=${INSTALL_DIR};make;make install;cd ...

#2. SZIP-----------------------------------------
#szip-2.1.1: https://docs.hdfgroup.org/archive/support/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
echo "...compiling szip..."
tar -xzf szip-2.1.1.tar.gz; cd szip-2.1.1;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#3. JPEG-----------------------------------------
#jpegsrc.v9f: https://www.ijg.org/files/
echo "...compiling jpegsrc..."
tar -xzf jpegsrc.v9f.tar.gz; cd jpeg-9f;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#4. PNG---------------------------------------
#libpng-1.6.43: http://www.libpng.org/pub/png/libpng.html
echo "...compiling libpng..."
tar -xzf libpng-1.6.44.tar.gz; cd libpng-1.6.44;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#5. Jasper------------------------------------
echo "...compiling jasper..."
#jasper-1.900.29 
tar -xzf jasper-1.900.29.tar.gz; cd jasper-1.900.29; ./configure --prefix=${INSTALL_DIR};make; make install; cd ..

#6. HDF5-----------------------------------------
#hdf5_1.14.5.tar.gz: https://github.com/HDFGroup/hdf5/releases
#Threadsafe+Unsupported to ensure cdo can chain nc4 data and high level libraries can be built, remove them if HDF5 breaks
echo "...compiling hdf5..."
tar -xzf hdf5_1.14.5.tar.gz; cd hdf5-hdf5_1.14.5;./configure --prefix=${INSTALL_DIR} --enable-hl --enable-build-mode=production --with-pic --with-szlib=${INSTALL_DIR} --enable-threadsafe --enable-unsupported;make;make install;cd ..

#7. NetCDF4(need HDF5)---------------------------
#netcdf-4.9.2: https://downloads.unidata.ucar.edu/netcdf/
echo "...compiling netcdf-c..."
tar -xzf netcdf-c-4.9.2.tar.gz; cd netcdf-c-4.9.2;./configure --prefix=${INSTALL_DIR} --enable-shared --enable-netcdf-4 --disable-libxml2 --disable-byterange;make;make install;cd ..

#*NetCDF4(extra)---------------
#netcdf-cxx4-4.3.1
echo "...compiling netcdf-cxx..."
tar -xzf netcdf-cxx4-4.3.1.tar.gz; cd netcdf-cxx4-4.3.1;./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install;cd ..

#netcdf-fortran-4.6.1
echo "...compiling netcdf-fortran..."
tar -xzf netcdf-fortran-4.6.1.tar.gz; cd netcdf-fortran-4.6.1;./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install;cd ..

#8. CDO-----------------------------------
#cdo-2.4.4: https://code.mpimet.mpg.de/projects/cdo
echo "...compiling cdo..."
tar -xzf cdo-2.4.4.tar.gz; cd cdo-2.4.4;./configure --prefix=${INSTALL_DIR} --with-netcdf=${INSTALL_DIR} --with-hdf5=${INSTALL_DIR} --with-szlib=${INSTALL_DIR}; make; make install; cd ..

echo "Job completed!"
