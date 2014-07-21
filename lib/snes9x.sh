source "$(dirname $BASH_SOURCE)/system.sh"
source "$(dirname $BASH_SOURCE)/utils.sh"
source "$(dirname $BASH_SOURCE)/deb.sh"

readonly SNES9X_DEB_URL="file://$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../deb/snes9x-libretro_0d7b3bc021c8c52c2590f9eac36c440fae781e802_amd64.deb"

readonly SNES9X_SRC_URL="https://github.com/libretro/snes9x/archive/d7b3bc021c8c52c2590f9eac36c440fae781e802.zip"
readonly SNES9X_VERSION="d7b3bc021c8c52c2590f9eac36c440fae781e802"
readonly SNES9X_SRC_PATH="/usr/local/src/snes9x_${SNES9X_VERSION}"
readonly SNES9X_BUILD_PATH="/tmp/snes9x_build"
readonly SNES9X_BUILD_DEPENDENCIES="build-essential"
readonly SNES9X_DEB_DEPENDENCIES="retroarch"

snes9x_install_build_dependencies() {
  install_packages $SNES9X_BUILD_DEPENDENCIES
}

snes9x_download_sources() {
  download_and_extract_archive $SNES9X_SRC_URL /tmp/snes9x
  rm --recursive --force $SNES9X_SRC_PATH
  mv --force /tmp/snes9x/snes9x-$SNES9X_VERSION $SNES9X_SRC_PATH
}

snes9x_compile() {
  cd $SNES9X_SRC_PATH/libretro
  make
  rm --recursive --force $SNES9X_BUILD_PATH
  mkdir --parents $SNES9X_BUILD_PATH/lib
  cp snes9x_libretro.so $SNES9X_BUILD_PATH/lib/
}

snes9x_build_package() {
  local dst_dir=$1
  declare_debian_package_dependencies snes9x $SNES9X_DEB_DEPENDENCIES
  build_debian_package $SNES9X_BUILD_PATH snes9x-libretro 0${SNES9X_VERSION} lib/
  mv snes9x-libretro_0${SNES9X_VERSION}_amd64.deb $dst_dir/
}

snes9x_install_package() {
  install_packages $SNES9X_DEB_DEPENDENCIES
  install_package_from_url $SNES9X_DEB_URL snes9x-libretro
}
