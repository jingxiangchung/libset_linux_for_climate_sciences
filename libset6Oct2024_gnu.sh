#!/bin/bash
#Written by Jing Xiang CHUNG on 6/10/2024
#A script to compile all libraries frequently used by our research.

##START

#Getting everything ready------------------------
INSTALL_DIR='/opt/gfort_compiled'

export LD_LIBRARY_PATH=${INSTALL_DIR}/lib:${LD_LIBRARY_PATH}
export LDFLAGS="$LDFLAGS -L${INSTALL_DIR}/lib"
export CPPFLAGS="${CPPFLAGS} -I${INSTALL_DIR}/include"
export CFLAGS=-fPIC
export PATH=${INSTALL_DIR}/bin:${PATH}

#*Install/set up needed prerequisites-------------
sudo apt-get update
#Libraries that I lazy to compiled manually (especially the bazillion of libraries needed by Python which Python dislikes if we compiled them manually)
#For Ubuntu 22.04
#sudo apt-get install build-essential g++ gfortran gcc bison flex m4 libexpat1-dev cmake libxml2-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libcurl4-openssl-dev wget pkg-config gdb lcov pkg-config libbz2-dev libffi-dev libgdbm-compat-dev liblzma-dev libreadline6-dev libsqlite3-dev sqlite3 lzma lzma-dev tk-dev uuid-dev zlib1g-dev libmpdec-dev csh libswitch-perl

#For Ubuntu 24.04
sudo apt-get install build-essential g++ gfortran gcc bison flex m4 libexpat1-dev cmake libxml2-dev libncurses-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libcurl4-openssl-dev wget pkg-config gdb lcov pkg-config libbz2-dev libffi-dev libgdbm-compat-dev liblzma-dev libreadline-dev libsqlite3-dev sqlite3 lzma lzma-dev tk-dev uuid-dev zlib1g-dev csh libswitch-perl

#1. OPENMPI--------------------------------------
#openmpi-5.0.5: https://www.open-mpi.org/
echo "...compiling openmpi..."
tar -xzvf openmpi-5.0.5.tar.gz; cd openmpi-5.0.5;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#2. SZIP-----------------------------------------
#szip-2.1.1: https://docs.hdfgroup.org/archive/support/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
echo "...compiling szip..."
tar -xzvf szip-2.1.1.tar.gz; cd szip-2.1.1;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#3. JPEG-----------------------------------------
#jpegsrc.v9f: https://www.ijg.org/files/
echo "...compiling jpegsrc..."
tar -xzvf jpegsrc.v9f.tar.gz; cd jpeg-9f;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#4. PNG---------------------------------------
#libpng-1.6.43: http://www.libpng.org/pub/png/libpng.html
echo "...compiling libpng..."
tar -xzvf libpng-1.6.43.tar.gz; cd libpng-1.6.43;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#5. TIFF----------------------------------
#tiff-4.6.0t: http://www.libtiff.org/downloads/
echo "...compiling tiff..."
tar -xzvf tiff-4.6.0t.tar.gz; cd tiff-4.6.0t; ./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#6. HDF4-----------------------------------------
#hdf-4.3.0: https://github.com/HDFGroup/hdf4/releases
echo "...compiling hdf4..."
tar -xzvf hdf4.3.0.tar.gz; cd hdfsrc;./configure --prefix=${INSTALL_DIR} --enable-shared --disable-fortran --enable-production --with-pic -with-szlib=${INSTALL_DIR} --with-jpeg=${INSTALL_DIR} --disable-netcdf;make;make install;cd ..

#7. HDF5-----------------------------------------
#hdf5-1.14.4-3: https://github.com/HDFGroup/hdf5/releases
#Threadsafe+Unsupported to ensure cdo can chain nc4 data and high level libraries can be built, remove them if HDF5 breaks
echo "...compiling hdf5..."
tar -xzvf hdf5-1.14.4-3.tar.gz; cd hdf5-1.14.4-3;./configure --prefix=${INSTALL_DIR} --enable-hl --enable-build-mode=production --with-pic --with-szlib=${INSTALL_DIR} --enable-threadsafe --enable-unsupported CFLAGS=-fPIC --enable-parallel;make;make install;cd ..

#8. PNetCDF---------------------------------------
#PnetCDF-1.13.0: https://parallel-netcdf.github.io/
echo "...compiling pnetcdf..."
tar -xzvf pnetcdf-1.13.0.tar.gz; cd pnetcdf-1.13.0; ./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install; cd ..

#9. NetCDF4(need HDF5)---------------------------
#netcdf-4.9.2: https://downloads.unidata.ucar.edu/netcdf/
echo "...compiling netcdf-c..."
tar -xzvf netcdf-c-4.9.2.tar.gz; cd netcdf-c-4.9.2;./configure --prefix=${INSTALL_DIR} --enable-shared --enable-netcdf-4 --enable-hdf4 --enable-pnetcdf;make;make install;cd ..

#*NetCDF4(extra)---------------
#netcdf-cxx4-4.3.1
echo "...compiling netcdf-cxx..."
tar -xzvf netcdf-cxx4-4.3.1.tar.gz; cd netcdf-cxx4-4.3.1;./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install;cd ..

#netcdf-fortran-4.6.1
echo "...compiling netcdf-fortran..."
tar -xzvf netcdf-fortran-4.6.1.tar.gz; cd netcdf-fortran-4.6.1;./configure --prefix=${INSTALL_DIR} --enable-shared;make;make install;cd ..

#10. Jasper------------------------------------
#WARNING [18/9/2024]: Do not use new version of JASPER if you want WRF's WPS ungrib to work, BUT, if you use old jasper, eccodes will not work... Here, we will be installing new Jasper. Please compile the libraries needed by WPS separately (look in the "external" folder in WPS source code)
echo "...compiling jasper..."
#jasper-1.900.29
#tar -xzvf jasper-1.900.29.tar.gz; cd jasper-1.900.29; ./configure --prefix=${LEGACY_DIR};make; make install; cd ..

#jasper-4.2.4: https://github.com/jasper-software/jasper
tar -xzvf jasper-4.2.4.tar.gz; cd jasper-4.2.4; [[ ! -d ../jasper_build ]] && mkdir ../jasper_build;SOURCE_DIR="`pwd`"; BUILD_DIR="../jasper_build"; cmake -G "Unix Makefiles" -H${SOURCE_DIR} -B${BUILD_DIR} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DJAS_ENABLE_LIBJPEG=true -DJAS_ENABLE_SHARED=true; cd ${BUILD_DIR}; make clean all; make install; cd ..

#11. AEC-------------------------------------
#libaec-1.1.3: https://gitlab.dkrz.de/k202009/libaec/-/tags
echo "...compiling libaec..."
tar -xzvf libaec-1.1.3.tar.gz; cd libaec-1.1.3; ./configure --prefix=${INSTALL_DIR}; make;make install;cd ..

#12. Eccodes--------------------------------
#eecides02.37.0: https://github.com/ecmwf/eccodes/releases
echo "...compiling eccodes..."
tar -xzvf eccodes-2.37.0-Source.tar.gz; cd eccodes-2.37.0-Source; [[ ! -d ../eccodes_build ]] && mkdir ../eccodes_build; SOURCE_DIR="`pwd`"; BUILD_DIR="../eccodes_build"; cd ../eccodes_build; cmake -G "Unix Makefiles" -H${SOURCE_DIR} -B${BUILD_DIR} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DENABLE_NETCDF=ON -DENABLE_JPG=ON -DENABLE_PNG=ON; make; make install; cd ..

#13. ANTLR----------------------------------
#antlr-2.7.7 (NCO does not work with new antlr): https://github.com/nco/antlr2
echo "...compiling antlr2..."
tar -xzvf antlr2-antlr2-2.7.7-1.tar.gz; cd antlr2-antlr2-2.7.7-1;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#14. UDUNITS--------------------------------
#udunits-2.2.28: https://downloads.unidata.ucar.edu/udunits/
echo "...compiling udunits..."
tar -xzvf udunits-2.2.28.tar.gz; cd udunits-2.2.28;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#15. Proj----------------------------------
#proj-9.4.1: https://proj.org/en/9.4/download.html
echo "...compiling proj..."
tar -xzvf proj-9.4.1.tar.gz; cd proj-9.4.1 ; [[ ! -d ../proj_build ]] && mkdir ../proj_build; SOURCE_DIR="`pwd`"; BUILD_DIR="../proj_build"; cd ../proj_build; cmake -G "Unix Makefiles" -H${SOURCE_DIR} -B${BUILD_DIR} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}; make; make install; cd ..

#16. CDO-----------------------------------
#cdo-2.4.3: https://code.mpimet.mpg.de/projects/cdo
echo "...compiling cdo..."
tar -xzvf cdo-2.4.3.tar.gz; cd cdo-2.4.3;./configure --prefix=${INSTALL_DIR} --with-netcdf=${INSTALL_DIR} --with-hdf5=${INSTALL_DIR} --with-szlib=${INSTALL_DIR} --with-udunits2=${INSTALL_DIR} --with-eccodes=${INSTALL_DIR} --with-proj=${INSTALL_DIR} --with-libxml2=yes; make; make install; cd ..

#17. NCO-------------------------------------
#nco-5.2.8: https://github.com/nco/nco/releases
echo "...compiling nco..."
tar -xzvf nco-5.2.8.tar.gz; cd nco-5.2.8;./configure --prefix=${INSTALL_DIR} --enable-netcdf-4 --enable-udunits2 CPPFLAGS="-I${INSTALL_DIR}/include" NETCDF_INC=/${INSTALL_DIR}/include NETCDF_LIB=${INSTALL_DIR}/lib NETCDF_ROOT=${INSTALL_DIR} UDUNITS2_PATH=${INSTALL_DIR} ANTLR_ROOT=${INSTALL_DIR};make;make install;cd ..

#18. Shapelib------------------------------
#shapelib-1.6.1: https://github.com/OSGeo/shapelib
echo "...compiling shapelib..."
tar -xzvf shapelib-1.6.1.tar.gz; cd shapelib-1.6.1;./configure --prefix=${INSTALL_DIR};make;make install; cd ..

#19. *Python-------------------------------
#Python-3.12.6: https://www.python.org/downloads/source/
echo "...compiling python..."
tar -xzvf Python-3.12.6.tgz; cd Python-3.12.6;./configure --with-openssl-rpath=auto --prefix=${INSTALL_DIR} --enable-loadable-sqlite-extensions --enable-optimizations;make;make install;cd ..

#20. *grads-grads-2.1.0.oga.1 (opengrads)---
echo "...setting up opengrads..."
echo '......please add line: export PATH=/opt/opengrads-2.2.1:${PATH} to the end of your ~/.bashrc file...'
tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz; cp -rf opengrads-2.2.1.oga.1/Contents /opt/opengrads-2.2.1

#IMPOARTANT: Put the following lines in your ~/.bashrc
#INSTALL_DIR='/opt/gfort_compiled'
#export PATH=${INSTALL_DIR}/bin:${PATH}
#export PATH=/opt/opengrads-2.2.1:${PATH}

#export GASCRP=<location where you kept gscripts folder>/gscripts

#export CDO_TIMESTAT_DATE="last"

##END

##NOTE: Below are other compilation commands used in the past they could be helpful in some certain cases:
#zlib-1.3.1: https://github.com/madler/zlib/releases 
#[15/9/2024: I do not want to manually compile zlib, since Python seems not to favour the zlib compiled manually. Not going to waste time trying to get it to work.] - will just use the apt-get version
###tar -xzvf zlib-1.3.1.tar.gz; cd zlib-1.3.1;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#Should OpenDAP support is wanted 
#[15/9/2024: I do not want to manually compile curl due to how openssl and curl can be mismatching, getting them to work together is a chore] - will just use the apt-get version
##openssl-3.0.15 (LTS ver.): https://openssl-library.org/source/index.html
#tar -xzvf openssl-3.0.15.tar.gz ;cd openssl-3.0.15;./Configure --prefix=${INSTALL_DIR} --openssldir=${INSTALL_DIR} --with-zlib-include=${INSTALL_DIR} --with-zlib-lib=${INSTALL_DIR};make;make install;cd ..

#libpsl-0.21.5: https://github.com/rockdaboot/libpsl/releases
#tar -xzvf libpsl-0.21.5.tar.gz; cd libpsl-0.21.5;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

##curl-8.10.0: https://curl.se/download.html
##tar -xzvf curl-8.10.0.tar.gz; cd curl-8.10.0;./configure --prefix=${INSTALL_DIR} --with-zlib=${INSTALL_DIR} --with-openssl=${INSTALL_DIR} CPPFLAGS="${CPPFLAGS} -I${INSTALL_DIR}/include" LDFLAGS="$LDFLAGS -L${INSTALL_DIR}/lib64" CFLAGS=-fPIC --enable-versioned-symbols;make;make install;cd ..

#sqlite3--------------------------
##sqlite-autoconf-3460100: https://www.sqlite.org/download.html - [15/9/2024: Sqlite compiled did work with Python, but since we already installing everything needed by Python from apt-get, might as well not ...compiling it manually.]
#tar -xzvf sqlite-autoconf-3460100.tar.gz; cd sqlite-autoconf-3460100;./configure --prefix=${INSTALL_DIR} CPPFLAGS="${CPPFLAGS} -I${INSTALL_DIR}/include" LDFLAGS="$LDFLAGS -L${INSTALL_DIR}/lib" CFLAGS=-fPIC LD_LIBRARY_PATH=${INSTALL_DIR}/lib:${LD_LIBRARY_PATH} -–enable-loadable-sqlite-extensions;make;make install;cd ..

#jasper-4.2.4: https://github.com/jasper-software/jasper
#tar -xzvf jasper-4.2.4.tar.gz; cd jasper-4.2.4; [[ ! -d ../jasper_build ]] && mkdir ../jasper_build;SOURCE_DIR="`pwd`"; BUILD_DIR="../jasper_build"; cmake -G "Unix Makefiles" -H${SOURCE_DIR} -B${BUILD_DIR} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DJAS_ENABLE_LIBJPEG=true -DJAS_ENABLE_SHARED=true; cd ${BUILD_DIR}; make clean all; make test ARGS="-V"; make install; cd ..

#Eccodes----------------------------
#eccodes-2.37.0-Source (for quicker ctest, extract eccodes_test_data.tar.gz, and move the content to eccodes-2.5.0-Source/build/data)
#tar -xzvf eccodes-2.37.0-Source.tar.gz; tar -xzvf eccodes_test_data.tar.gz; cd eccodes-2.37.0-Source; [[ ! -d ../eccodes_build ]] && mkdir ../eccodes_build; SOURCE_DIR="`pwd`"; BUILD_DIR="../eccodes_build"; cd ../eccodes_build; cmake -G "Unix Makefiles" -H${SOURCE_DIR} -B${BUILD_DIR} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DENABLE_NETCDF=ON -DENABLE_JPG=ON; make; cp -rf ../data .; rm -rf ../data;ctest; make install; cd ..

#wgrib2.v2.0.5----------------------
#1. Extract the archive downloaded
#2. Type make
#3. Copy the directory to somewhere
#4. Set the environment to link up this somewhere (see below)

#ps2eps-1.68-----------------------
#1. Extract the archive download
#2. Copy the directory to somewhere
#3. cd to <somewhere>/ps2eps/src/C
#4. Type cc -o bbox bbox.c
#5. Set the environment to link up this somewhere (see below)

#Imagemagick------------------------
##Setting up dependencies (Caution: ~108MB)--------------
#sudo apt-get build-dep imagemagick

##ImageMagick-7.0.7-8
#cd ImageMagick-7.0.7-8;./configure --prefix=${INSTALL_DIR};make;make install;cd ..

#HDF4 CF Conversion Toolkit--------
##hdf-eos2-3.0: https://wiki.earthdata.nasa.gov/display/DAS/Toolkit+Downloads
#cd hdf-eos2-3.0;./configure --prefix=${INSTALL_DIR} CPPFLAGS="${CPPFLAGS} -I${INSTALL_DIR}/include" LDFLAGS="$LDFLAGS -L${INSTALL_DIR}/lib" CFLAGS=-fPIC;make;make install;cd ..

#h4cflib_1.3: https://hdfeos.org/software/h4cflib/ (note: the tar.gz file is not really zipped, thus unpack using tar -xvf)
#NOT WORKING WITH UBUNTU 22
#cd cd h4cf-1.3;./configure --prefix=${INSTALL_DIR} --with-jpeg=${INSTALL_DIR} --with-zlib=${INSTALL_DIR} --with-hdf4=${INSTALL_DIR} --with-hdfeos2=${INSTALL_DIR} --with-netcdf=${INSTALL_DIR} --with-hdf5=${INSTALL_DIR} --with-szlib=${INSTALL_DIR};make;make install;cd ..

#NCL-------------------------------
#ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492
#1. Extract the archive downloaded
#2. Copy the directory to somewhere
#3. Set the environment to link up this somewhere (see below)

#ecmwf-api-client--------------------
#pip3 install ecmwf-api-client
#Note: might need to add lines below to ECMWF MARS .py script before able to download data
#import socket
#import ssl
#ssl._create_default_https_context = ssl._create_unverified_context

#Environment in .bashrc [OBSOLETE, BUT MIGHT BE USEFUL FOR CERTAIN CASES]----
#Add in the following lines (not including the # symbol), whichever necessary to ~/.bashrc file

##export LD_LIBRARY_PATH=/opt/intel/lib/intel64:${LD_LIBRARY_PATH}
##source /opt/intel/bin/compilervars.sh intel64

##export PATH=/opt/ifort_compiled/bin:${PATH}

#export PATH=/opt/gfort_compiled/bin:${PATH}
#export PATH=/opt/grads-2.1.0.oga.1/Contents:${PATH}
#export PATH=/opt/grib2/wgrib2:${PATH}
#export PATH=/opt/ps2eps/bin:${PATH}
#export PATH=/opt/ps2eps/src/C:${PATH}

#export GASCRP=${HOME}/Downloads/MySrc/gscripts
#export CDO_TIMESTAT_DATE="last"

#export LD_LIBRARY_PATH=/opt/gfort_compiled/lib:${LD_LIBRARY_PATH}

#export NCARG_ROOT=/opt/ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492;export PATH=$NCARG_ROOT/bin:$PATH

echo "Job completed!"
