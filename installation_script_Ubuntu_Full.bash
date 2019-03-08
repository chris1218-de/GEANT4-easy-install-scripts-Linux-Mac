#!/bin/bash
set -e

#################
mkdir -p geant4 # directory were everything is built and installed
cd geant4
############# 

########################## VARIABLES

##############  PROGRAMS' VERSIONS AND URLs : MAY CHANGE IN THE FUTURE
#g4_version=10.5
#_g4_version=10.05
g4_version=10.4.p03
_g4_version=10.04.p03
folder_g4_version=Geant4-10.4.3
g4_url=("http://cern.ch/geant4-data/releases/geant4.${_g4_version}.tar.gz")

xerces_w_ver=xerces-c-3.2.0
xerces_arc=${xerces_w_ver}.tar.gz
xerces_url=("http://archive.apache.org/dist/xerces/c/3/sources/$xerces_arc")

casmesh_w_ver=1.1
casmesh_arc=v${casmesh_w_ver}.tar.gz
casmesh_url=("https://github.com/christopherpoole/CADMesh/archive/v$casmesh_w_ver.tar.gz")

matio_folder=matio-cmake
matio_git_repo=https://github.com/massich/$matio_folder.git

<<<<<<< HEAD
=======
hdf5_version=1_10_5
hdf5_ar_name=hdf5-$hdf5_version.tar.gz
hdf5_basename=hdf5-hdf5-$hdf5_version
hdf5_url=https://github.com/live-clones/hdf5/archive/$hdf5_ar_name

>>>>>>> 3f7b94b929644aa0466ecde7c4a33dd0586c5a7a
####################################################

# CMake command
CMake_path=../../cmake/bin/cmake

#
current_dir=$PWD

# Parameters
core_nb=`grep -c ^processor /proc/cpuinfo`

base_dir=$PWD

# Geant4
src_dir=$base_dir/source_geant4.${_g4_version}/
build_dir=$base_dir/geant4_build_${_g4_version}/
install_dir=$base_dir/geant4_install_${_g4_version}/
geant4_lib_dir=${install_dir}/lib/${folder_g4_version}/

# XERCES-C

xercesc_build_dir=($base_dir/build_xercesc/)
xercesc_install_dir=($base_dir/install_xercesc/)
xercesc_inc_dir=(${xercesc_install_dir}/include)
xercesc_lib_dir=(${xercesc_install_dir}/lib64/libxerces-c-3.2.so)

# CADMESH

casmesh_build_dir=($base_dir/build_cadmesh/)
casmesh_install_dir=($base_dir/install_cadmesh/)

# MATIO

matio_build_dir=($base_dir/build_matio/)
matio_install_dir=($base_dir/install_matio/)

<<<<<<< HEAD
=======
# HDF5

hdf5_build_dir=($base_dir/build_hdf5/)
hdf5_install_dir=($base_dir/install_hdf5/)

>>>>>>> 3f7b94b929644aa0466ecde7c4a33dd0586c5a7a
########## Creating folders

  mkdir -p ${build_dir} # -p will create only if it does not exist yet
  mkdir -p ${src_dir}
  mkdir -p ${install_dir}

  mkdir -p $casmesh_build_dir
  mkdir -p $casmesh_install_dir

  mkdir -p $xercesc_build_dir
  mkdir -p $xercesc_install_dir

  mkdir -p $matio_build_dir
  mkdir -p $matio_install_dir

<<<<<<< HEAD
=======
  mkdir -p $hdf5_build_dir
  mkdir -p $hdf5_install_dir

>>>>>>> 3f7b94b929644aa0466ecde7c4a33dd0586c5a7a
############# CHECK IF OS IS UBUNTU
echo "checking if OS is Ubuntu..."
# Checking if OS is Ubuntu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
fi

if [ ! "$OS" = "Ubuntu" ]; then
  echo "Error: OS is not Ubuntu. Script works only for Ubuntu. Aborting."
  exit 1
else
  echo "... OS is Ubuntu"
fi
############# 

#########################################################################
############# CHECK IF DEPENDENCIES ARE SATISFIED, OTHERWISE INSTALL THEM

ubuntu_dependences_list=( "build-essential" 
"qt4-default" 
"qtcreator" 
"cmake-qt-gui" 
"gcc" 
"g++" 
"gfortran" 
"zlib1g-dev" 
"libxerces-c-dev" 
"libx11-dev" 
"libexpat1-dev" 
"libxmu-dev" 
"libmotif-dev" 
"libboost-filesystem-dev" 
"libeigen3-dev" 
"qt4-qmake"
<<<<<<< HEAD
"libhdf5-serial-dev"
=======
#"libhdf5-serial-dev"
>>>>>>> 3f7b94b929644aa0466ecde7c4a33dd0586c5a7a
)

entered_one_time=true

run_install()
{
    echo "Some missing dependencies were detected."
    ## Prompt the user 
    if [ entered_one_time=true ]; then
      entered_one_time=false
      read -p "Do you have (root) sudo access ? [Y/n]. It is required to install missing dependencies: " answer
      ## Set the default value if no answer was given
      answer=${answer:N}
      if [[ $answer =~ [Nn] ]]; then
        echo "root access is required to install missing dependencies. Aborting."
        exit 1
      fi
    fi
    ## Prompt the user 
    read -p "Do you want to install missing dependencies? [Y/n]: " answer
    ## Set the default value if no answer was given
    answer=${answer:Y}
    ## If the answer matches y or Y, install
    if [[ $answer =~ [Yy] ]]; then
      sudo apt-get install ${ubuntu_dependences_list[@]}
    else
      echo "Missing dependencies are required for proper compilation and installation. Aborting."
      exit 0
    fi
}


echo "checking dependencies..."

dpkg -s "${ubuntu_dependences_list[@]}" >/dev/null 2>&1 || run_install

echo "... dependencies are satisfied."

#########################################################################

<<<<<<< HEAD
=======
#### HDF5 (requirement of MATIO)

rm -rf $hdf5_ar_name
wget $hdf5_url
tar zxf $hdf5_ar_name

cd $hdf5_build_dir
echo "build of hdf5: Attempt to execute CMake..."

rm -rf CMakeCache.txt

$CMake_path \
      -DCMAKE_INSTALL_PREFIX=${hdf5_install_dir} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      ../$hdf5_basename/
echo "... done"

echo "Attempt to compile and install hdf5"

  G4VERBOSE=1 make -j${core_nb}
  make install

cd $base_dir
echo "... done"

>>>>>>> 3f7b94b929644aa0466ecde7c4a33dd0586c5a7a
#### MATIO (to be able to write matlab output files)

rm -rf $matio_folder
git clone --recursive https://github.com/massich/matio-cmake.git

cd $matio_build_dir

echo "build of matio: Attempt to execute CMake..."

rm -rf CMakeCache.txt

<<<<<<< HEAD
=======
hdf5_cmake_dir=${hdf5_install_dir}/share/cmake/hdf5
hdf5_diff_exe=${hdf5_install_dir}/bin/h5diff

>>>>>>> 3f7b94b929644aa0466ecde7c4a33dd0586c5a7a
$CMake_path \
      -DCMAKE_INSTALL_PREFIX=${matio_install_dir} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
<<<<<<< HEAD
=======
      -DMAT73=ON \
      -DDEFAULT_FILE_VERSION=7.3 \
      -DLINUX=ON \
      -DHDF5_DIR=$hdf5_cmake_dir \
      -DHDF5_DIFF_EXECUTABLE=$hdf5_diff_exe \
>>>>>>> 3f7b94b929644aa0466ecde7c4a33dd0586c5a7a
      ../$matio_folder/
echo "... done"

echo "Attempt to compile and install matio"

  G4VERBOSE=1 make -j${core_nb}
  make install

cd $base_dir
echo "... done"

#### XERCES-C (to be able to use GDML files)

## download xerces-c (for GDML)

wget $xerces_url
tar zxf $base_dir/$xerces_arc
rm -rf $xerces_arc

xerces_src=$base_dir/$xerces_w_ver

## compile and install xerces-c

cd $xercesc_build_dir

echo "build of xerces-c: Attempt to execute CMake..."

rm -rf CMakeCache.txt

$CMake_path \
      -DCMAKE_INSTALL_PREFIX=${xercesc_install_dir} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib64 \
      $xerces_src
echo "... done"

echo "Attempt to compile and install xerces-c"

  G4VERBOSE=1 make -j${core_nb}
  make install

cd $base_dir
echo "... done"

#### GEANT4

## download Geant4

rm -rf ${src_dir}
wget $g4_url
tar zxf geant4.${_g4_version}.tar.gz
mv geant4.${_g4_version} ${src_dir}
rm -rf geant4.${_g4_version}.tar.gz

## compile and install Geant4

  cd ${build_dir}
  rm -rf CMakeCache.txt

echo "build_geant4: Attempt to execute CMake"
  
      $CMake_path \
      -DCMAKE_INSTALL_PREFIX=${install_dir} \
      -DCMAKE_BUILD_TYPE=Release \
      -DGEANT4_BUILD_MULTITHREADED=OFF \
      -DGEANT4_BUILD_CXXSTD=c++11 \
      -DGEANT4_INSTALL_DATA=ON \
      -DGEANT4_USE_GDML=ON \
      -DGEANT4_USE_G3TOG4=ON \
      -DGEANT4_USE_QT=ON \
      -DGEANT4_FORCE_QT4=ON \
      -DGEANT4_USE_XM=ON \
      -DGEANT4_USE_OPENGL_X11=ON \
      -DGEANT4_USE_INVENTOR=OFF \
      -DGEANT4_USE_RAYTRACER_X11=ON \
      -DGEANT4_USE_SYSTEM_CLHEP=OFF \
      -DGEANT4_USE_SYSTEM_EXPAT=OFF \
      -DGEANT4_USE_SYSTEM_ZLIB=OFF \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DXERCESC_INCLUDE_DIR=${xercesc_inc_dir} \
      -DXERCESC_LIBRARY=${xercesc_lib_dir} \
      ../source_geant4.${_g4_version}/

echo "... Done"

echo "Attempt to compile and install Geant4"

  G4VERBOSE=1 make -j${core_nb}

  make install

cd $base_dir
echo "... Done"

#### CADMESH
# CADMESH is a CAD file interface for GEANT4, made by Poole, C. M. et al.
# See https://github.com/christopherpoole/CADMesh

## download CADMESH

wget $casmesh_url
tar zxf $base_dir/$casmesh_arc
rm -rf $casmesh_arc

casmesh_src=$base_dir/CADMesh-$casmesh_w_ver

## compile and install CADMESH

cd $casmesh_build_dir

echo "build of CADMESH: Attempt to execute CMake..."

rm -rf CMakeCache.txt

$CMake_path \
      -DCMAKE_INSTALL_PREFIX=${casmesh_install_dir} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DGeant4_DIR=$geant4_lib_dir \
      $casmesh_src

echo "... done"

echo "Attempt to compile and install CADMESH"

  G4VERBOSE=1 make -j${core_nb}
  make install

cd $base_dir

echo "... done"


#########################################################################
#########################################################################
#### set environement variables into '~/.bashrc'

echo "Attempt to setup up environement variables..."

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

set_environement() {

cd $base_dir

  if grep -Fxq "$1" ~/.bashrc
  then
    echo -e "${GREEN}< source $1 > already set up in ~/.bashrc.${NC}"          
  else
    echo "    " >> ~/.bashrc
    echo "## --> Added by Geant4 installation script" >> ~/.bashrc
    echo $1 >> ~/.bashrc
    echo "## <-- Added by Geant4 installation script" >> ~/.bashrc
    echo "______"
    echo -e "${GREEN}added ${RED}$1${GREEN} to ${RED}~/.bashrc${GREEN} file.${NC}"
  fi
}

# Geant4 + data
set_environement "source $install_dir/bin/geant4.sh"

# CADMesh
set_environement "export cadmesh_DIR=$casmesh_install_dir/lib/cmake/cadmesh-1.1.0/"
set_environement "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$casmesh_install_dir/include/"
set_environement "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$casmesh_install_dir/include/"
set_environement "export PATH=\$PATH:$casmesh_install_dir/include/"
set_environement "export LIBRARY_PATH=\$LIBRARY_PATH:$casmesh_install_dir/lib/"
set_environement "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$casmesh_install_dir/lib/"

# xerces-c
set_environement "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$xercesc_install_dir/include/"
set_environement "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$xercesc_install_dir/include/"
set_environement "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$xercesc_install_dir/lib64/"
set_environement "export LIBRARY_PATH=\$LIBRARY_PATH:$xercesc_install_dir/lib64/"
set_environement "export PATH=\$PATH:$xercesc_install_dir/include/"

# matio
set_environement "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$matio_install_dir/include/"
set_environement "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$matio_install_dir/include/"
set_environement "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$matio_install_dir/lib/"
set_environement "export LIBRARY_PATH=\$LIBRARY_PATH:$matio_install_dir/lib/"
set_environement "export PATH=\$PATH:$matio_install_dir/include/"

<<<<<<< HEAD
=======
# hdf5
set_environement "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$hdf5_install_dir/include/"
set_environement "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$hdf5_install_dir/include/"
set_environement "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$hdf5_install_dir/lib/"
set_environement "export LIBRARY_PATH=\$LIBRARY_PATH:$hdf5_install_dir/lib/"
set_environement "export PATH=\$PATH:$hdf5_install_dir/include/"

>>>>>>> 3f7b94b929644aa0466ecde7c4a33dd0586c5a7a
echo "... Done"
echo -e "${RED}Please excecute command < ${GREEN}source ~/.bashrc${RED} > or re-open a terminal for the system to be able to find the databases and libraries.${NC}"



