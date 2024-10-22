#!/bin/bash
#Written by Jing Xiang CHUNG on 12/10/2024
#A script to compile all libraries frequently used by our research on acroporaC.

#Getting everything ready------------------------
INSTALL_DIR='/home/jxchung/software/JX_compiled'
INSTALL_DIR_GCC='/home/jxchung/software/JX_compiled_gcc'

export LD_LIBRARY_PATH=${INSTALL_DIR}/lib64:${INSTALL_DIR}/lib:${INSTALL_DIR_GCC}/lib64:${INSTALL_DIR_GCC}/lib${LD_LIBRARY_PATH}
export LDFLAGS="$LDFLAGS -L${INSTALL_DIR}/lib64 -L${INSTALL_DIR}/lib -L${INSTALL_DIR_GCC}/lib64 -L${INSTALL_DIR_GCC}/lib"
export CPPFLAGS="${CPPFLAGS} -I${INSTALL_DIR}/include -I${INSTALL_DIR_GCC}/include"
export CFLAGS=-fPIC
export PATH=${INSTALL_DIR_GCC}/bin:${INSTALL_DIR}/bin:${PATH}

#0. GCC------------------------------------------
echo "...compiling gcc..."
tar -xzf gcc-11.5.0.tar.gz; cd gcc-11.5.0;sed -i "s:='wget:='wget --no-check-certificate:g" contrib/download_prerequisites;./contrib/download_prerequisites;./configure --prefix=${INSTALL_DIR_GCC} --disable-multilib --enable-host-shared; make; make install;cd ..

#1. OPENMPI--------------------------------------
#openmpi-5.0.5: https://www.open-mpi.org/
echo "...compiling openmpi..."
tar -xzf openmpi-5.0.5.tar.gz; cd openmpi-5.0.5;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#2. Zlib-----------------------------------------
#zlib-1.3.1.tar.gz: https://zlib.net/
echo "...compiling zlib..."
tar -xzf zlib-1.3.1.tar.gz; cd zlib-1.3.1;./configure --prefix=${INSTALL_DIR};make;make install;cd ...

#3. SZIP-----------------------------------------
#szip-2.1.1: https://docs.hdfgroup.org/archive/support/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
echo "...compiling szip..."
tar -xzf szip-2.1.1.tar.gz; cd szip-2.1.1;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#4. JPEG-----------------------------------------
#jpegsrc.v9f: https://www.ijg.org/files/
echo "...compiling jpegsrc..."
tar -xzf jpegsrc.v9f.tar.gz; cd jpeg-9f;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#5. PNG---------------------------------------
#libpng-1.6.43: http://www.libpng.org/pub/png/libpng.html
echo "...compiling libpng..."
tar -xzf libpng-1.6.44.tar.gz; cd libpng-1.6.44;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#6. Jasper------------------------------------
echo "...compiling jasper..."
#jasper-1.900.29 
tar -xzf jasper-1.900.29.tar.gz; cd jasper-1.900.29; ./configure --prefix=${INSTALL_DIR};make; make install; cd ..

#7. HDF5-----------------------------------------
#hdf5_1.14.5.tar.gz: https://github.com/HDFGroup/hdf5/releases
#Threadsafe+Unsupported to ensure cdo can chain nc4 data and high level libraries can be built, remove them if HDF5 breaks
echo "...compiling hdf5..."
tar -xzf hdf5_1.14.5.tar.gz; cd hdf5-hdf5_1.14.5;./configure --prefix=${INSTALL_DIR} --enable-hl --enable-build-mode=production --with-pic --with-szlib=${INSTALL_DIR} --enable-threadsafe --enable-unsupported --enable-parallel;make;make install;cd ..

#8. PNetCDF---------------------------------------
#PnetCDF-1.13.0: https://parallel-netcdf.github.io/
echo "...compiling pnetcdf..."
tar -xzvf pnetcdf-1.13.0.tar.gz; cd pnetcdf-1.13.0; ./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install; cd ..

#9. NetCDF4(need HDF5)---------------------------
#netcdf-4.9.2: https://downloads.unidata.ucar.edu/netcdf/
echo "...compiling netcdf-c..."
tar -xzf netcdf-c-4.9.2.tar.gz; cd netcdf-c-4.9.2;./configure --prefix=${INSTALL_DIR} --enable-shared --enable-netcdf-4 --disable-libxml2 --enable-pnetcdf --disable-byterange;make;make install;cd ..

#*NetCDF4(extra)---------------
#netcdf-cxx4-4.3.1
echo "...compiling netcdf-cxx..."
tar -xzf netcdf-cxx4-4.3.1.tar.gz; cd netcdf-cxx4-4.3.1;./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install;cd ..

#netcdf-fortran-4.6.1
echo "...compiling netcdf-fortran..."
tar -xzf netcdf-fortran-4.6.1.tar.gz; cd netcdf-fortran-4.6.1;./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install;cd ..

#10. CDO-----------------------------------
#cdo-2.4.4: https://code.mpimet.mpg.de/projects/cdo
echo "...compiling cdo..."
tar -xzf cdo-2.4.4.tar.gz; cd cdo-2.4.4;./configure --prefix=${INSTALL_DIR} --with-netcdf=${INSTALL_DIR} --with-hdf5=${INSTALL_DIR} --with-szlib=${INSTALL_DIR}; make; make install; cd ..

#11. Openssl-------------------------------
##openssl-3.3.2: https://openssl-library.org/source/index.html (Perl's issue, OpenSSL3 cannot be compiled)
echo "...compiling openssl..."
#tar -xzvf openssl-3.3.2.tar.gz;cd openssl-3.3.2;./Configure --prefix=${INSTALL_DIR} --openssldir=${INSTALL_DIR} --with-zlib-include=${INSTALL_DIR} --with-zlib-lib=${INSTALL_DIR} -fPIC -shared;make;make install;cd ..

#openssl-1.1.1: https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1w/openssl-1.1.1w.tar.gz
tar -xzf openssl-1.1.1w.tar.gz;cd openssl-1.1.1w;./config --prefix=${INSTALL_DIR} --openssldir=${INSTALL_DIR} --with-zlib-include=${INSTALL_DIR} --with-zlib-lib=${INSTALL_DIR} -fPIC -shared ; make; make install; cd ..

#https://github.com/openssl/openssl/releases/download/openssl-3.0.9/openssl-3.0.9.tar.gz

#12. libffi--------------------------------
#libffi-3.4.6: https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz (note: to fix Python ctest module)
tar -xzf libffi-3.4.6.tar.gz;cd libffi-3.4.6;./configure --prefix=${INSTALL_DIR}; make;make install; cd ..

#13. *Python-------------------------------
#Python 3.12.6: https://www.python.org/downloads/source/ (note: do not compile Python 3.13.0, it not working well with pip3 install netCDF4)
#Imperfect built, because we ignore installing some needed libraries.
echo "...compiling python..."
# tar -xzvf Python-3.13.0.tgz; cd Python-3.13.0;./configure --prefix=${INSTALL_DIR} --with-openssl=${INSTALL_DIR} --enable-loadable-sqlite-extensions --enable-optimizations;make;make install;cd ..
tar -xzf Python-3.12.6.tgz; cd Python-3.12.6;./configure --prefix=${INSTALL_DIR} --with-openssl=${INSTALL_DIR} --enable-optimizations;make;make install;cd ..

#14. Wget---------------------------------
#wget-1.20.2 (not working with acroporaC, give up... will just be using alias wget='wget --no-check-certificate'
#echo "...compiling wget..."
#export OPENSSL_CFLAGS="-I/home/jxchung/software/JX_compiled/include"
#export OPENSSL_LIBS="-L/home/jxchung/software/JX_compiled/lib"
#tar -xzf wget-1.20.2.tar.gz;cd wget-1.20.2;./configure --prefix=${INSTALL_DIR} --with-ssl=openssl;make;make install; cd ..

#Add the following lines into your .bashrc (without #)
#INSTALL_DIR='/home/jxchung/software/JX_compiled'
#INSTALL_DIR_GCC='/home/jxchung/software/JX_compiled_gcc'

#export LD_LIBRARY_PATH=${INSTALL_DIR}/lib64:${INSTALL_DIR}/lib:${INSTALL_DIR_GCC}/lib64:${INSTALL_DIR_GCC}/lib${LD_LIBRARY_PATH}
#export PATH=${INSTALL_DIR_GCC}/bin:${INSTALL_DIR}/bin:${PATH}

echo "Job completed!"
