source "$(dirname $BASH_SOURCE)/system.sh"
source "$(dirname $BASH_SOURCE)/utils.sh"
source "$(dirname $BASH_SOURCE)/deb.sh"
source "$(dirname $BASH_SOURCE)/sfml2.sh"

readonly ATTRACT_DEB_URL="file://$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../deb/attract-mode_1.3.1_amd64.deb"

readonly ATTRACT_SRC_URL="https://github.com/mickelson/attract/archive/v1.3.1.tar.gz"
readonly ATTRACT_VERSION="1.3.1"
readonly ATTRACT_SRC_PATH="/usr/local/src/attract_${ATTRACT_VERSION}"
readonly ATTRACT_BUILD_PATH="/tmp/attract_build"
readonly ATTRACT_BUILD_DEPENDENCIES="build-essential pkg-config libopenal-dev \
    libavformat-dev libavcodec-dev libavutil-dev libswscale-dev fontconfig \
    libglew-dev libgl1-mesa-dev libxrandr-dev libjpeg8-dev libsfml-dev"
readonly ATTRACT_DEB_DEPENDENCIES="libsfml libavformat53 libswscale2 libopenal1 \
    libglew1.7 libjpeg8 libxrandr2 ttf-freefont"

attract_install_build_dependencies() {
  install_package_from_url $SFML_DEB_URL libsfml
  install_package_from_url $SFML_DEV_DEB_URL libsfml-dev
  install_packages $ATTRACT_BUILD_DEPENDENCIES
}

attract_download_sources() {
  download_and_extract_archive $ATTRACT_SRC_URL /tmp/attract
  rm --recursive --force $ATTRACT_SRC_PATH
  mv --force /tmp/attract/attract-$ATTRACT_VERSION $ATTRACT_SRC_PATH
}

attract_compile() {
  cd $ATTRACT_SRC_PATH
  replace_config_line "prefix=/usr/local" "prefix=/usr" Makefile
  make
  rm --recursive --force $ATTRACT_BUILD_PATH
  mkdir --parents $ATTRACT_BUILD_PATH/share $ATTRACT_BUILD_PATH/bin
  mv attract $ATTRACT_BUILD_PATH/bin
  cp --recursive config $ATTRACT_BUILD_PATH/share/attract
}

attract_build_package() {
  local dst_dir=$1
  declare_debian_package_dependencies attract_mode $ATTRACT_DEB_DEPENDENCIES
  build_debian_package $ATTRACT_BUILD_PATH attract_mode $ATTRACT_VERSION bin/ share/
  mv attract-mode_${ATTRACT_VERSION}_amd64.deb $dst_dir
}

attract_install_package() {
  install_package_from_url $SFML_DEB_URL libsfml
  install_packages $ATTRACT_DEB_DEPENDENCIES
  install_package_from_url $ATTRACT_DEB_URL attract-mode
}
