source "$(dirname $BASH_SOURCE)/system.sh"
source "$(dirname $BASH_SOURCE)/utils.sh"
source "$(dirname $BASH_SOURCE)/deb.sh"

readonly SFML_DEB_URL="file://$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../deb/libsfml_2.1_amd64.deb"
readonly SFML_DEV_DEB_URL="file://$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../deb/libsfml-dev_2.1_amd64.deb"

readonly SFML_SRC_URL="http://sfml-dev.org/download/sfml/2.1/SFML-2.1-sources.zip"
readonly SFML_VERSION="2.1"
readonly SFML_SRC_PATH="/usr/local/src/sfml_${SFML_VERSION}"
readonly SFML_BUILD_PATH="/tmp/sfml_build"
readonly SFML_BUILD_DEPENDENCIES="libpthread-stubs0-dev libgl1-mesa-dev \
    libx11-dev libxrandr-dev libfreetype6-dev libglew1.5-dev libjpeg8-dev \
    libsndfile1-dev libopenal-dev cmake ttf-freefont build-essential"

sfml_install_build_dependencies() {
  install_packages $SFML_BUILD_DEPENDENCIES
}

sfml_download_sources() {
  download_and_extract_archive $SFML_SRC_URL /tmp/sfml
  rm --recursive --force $SFML_SRC_PATH
  mv --force /tmp/sfml/SFML-${SFML_VERSION} $SFML_SRC_PATH
}

# Instructions taken from
# http://sfmlcoder.wordpress.com/2011/08/16/building-sfml-2-0-with-make-for-gcc/
sfml_compile() {
  cd $SFML_SRC_PATH
  cmake -G "Unix Makefiles" -D CMAKE_BUILD_TYPE=Release \
      -D BUILD_SHARED_LIBS=TRUE -D CMAKE_INSTALL_PREFIX=$SFML_BUILD_PATH .
  make
  make install
  cmake -G "Unix Makefiles" -D CMAKE_BUILD_TYPE=Debug \
      -D BUILD_SHARED_LIBS=TRUE -D CMAKE_INSTALL_PREFIX=$SFML_BUILD_PATH .
  make
  make install
  cmake -G "Unix Makefiles" -D CMAKE_BUILD_TYPE=Release \
      -D BUILD_SHARED_LIBS=FALSE -D CMAKE_INSTALL_PREFIX=$SFML_BUILD_PATH .
  make
  make install
  cmake -G "Unix Makefiles" -D CMAKE_BUILD_TYPE=Debug \
      -D BUILD_SHARED_LIBS=FALSE -D CMAKE_INSTALL_PREFIX=$SFML_BUILD_PATH .
  make
  make install
}

sfml_build_package() {
  local dst_dir=$1
  build_debian_package $SFML_BUILD_PATH libsfml $SFML_VERSION lib/
  build_debian_package $SFML_BUILD_PATH libsfml-dev $SFML_VERSION include/
  mv libsfml*_${SFML_VERSION}_amd64.deb $dst_dir/
}
