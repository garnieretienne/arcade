source "$(dirname $BASH_SOURCE)/system.sh"
source "$(dirname $BASH_SOURCE)/utils.sh"
source "$(dirname $BASH_SOURCE)/deb.sh"

readonly RETROARCH_DEB_URL="file://$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../deb/retroarch_0.9.9_amd64.deb"
readonly RETROARCH_FILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../files/retroarch"

readonly RETROARCH_SRC_URL="https://github.com/libretro/RetroArch/archive/v0.9.9.tar.gz"
readonly RETROARCH_VERSION="0.9.9"
readonly RETROARCH_SRC_PATH="/usr/local/src/retroarch_${RETROARCH_VERSION}"
readonly RETROARCH_BUILD_PATH="/tmp/retroarch_build"
readonly RETROARCH_BUILD_DEPENDENCIES="build-essential libsdl1.2-dev xorg \
    pkg-config libasound2-dev"
readonly RETROARCH_DEB_DEPENDENCIES="libasound2 libpulse0 libsdl1.2debian xorg"

retroarch_install_build_dependencies() {
  install_packages $RETROARCH_BUILD_DEPENDENCIES
}

retroarch_download_sources() {
  download_and_extract_archive $RETROARCH_SRC_URL /tmp/retroarch
  rm --recursive --force $RETROARCH_SRC_PATH
  mv --force /tmp/retroarch/RetroArch-$RETROARCH_VERSION $RETROARCH_SRC_PATH
}

retroarch_compile() {
  cd $RETROARCH_SRC_PATH
  ./configure --enable-sdl --enable-threads --enable-alsa --prefix=/
  make
  make DESTDIR=$RETROARCH_BUILD_PATH install
}

retroarch_build_package() {
  local dst_dir=$1
  declare_debian_package_dependencies retroarch $RETROARCH_DEB_DEPENDENCIES
  build_debian_package $RETROARCH_BUILD_PATH retroarch $RETROARCH_VERSION etc/ bin/ share/
  mv retroarch_${RETROARCH_VERSION}_amd64.deb $dst_dir/
}

retroarch_install_package() {
  install_packages $RETROARCH_DEB_DEPENDENCIES
  install_package_from_url $RETROARCH_DEB_URL retroarch
}

retroarch_generate_config() {
  cat $RETROARCH_FILES_DIR/retroarch.cfg
}