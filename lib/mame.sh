source "$(dirname $BASH_SOURCE)/system.sh"
source "$(dirname $BASH_SOURCE)/utils.sh"
source "$(dirname $BASH_SOURCE)/deb.sh"

readonly MAME_DEB_URL="file://$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../deb/mame_0.153_amd64.deb"

readonly MAME_SRC_URL="http://mame.mirrors.zippykid.com/releases/mame0153s.zip"
readonly MAME_VERSION="0.153"
readonly MAME_SRC_PATH="/usr/local/src/mame_${MAME_VERSION}"
readonly MAME_BUILD_PATH="/tmp/mame"
readonly MAME_BUILD_DEPENDENCIES="build-essential libsdl1.2-dev libsdl-ttf2.0-dev \
    libqt4-dev libfontconfig1-dev libxinerama-dev"
readonly MAME_DEB_DEPENDENCIES="libasound2 libqtgui4 libsdl1.2debian \
    libsdl-ttf2.0-0 libxinerama1"

mame_install_build_dependencies() {
  install_packages $MAME_BUILD_DEPENDENCIES
}

mame_download_sources() {
  download_and_extract_archive $MAME_SRC_URL /tmp/mame
  mkdir --parents $MAME_SRC_PATH
  unzip -q /tmp/mame/mame.zip -d $MAME_SRC_PATH
  rm --force /tmp/mame/mame.zip
}

mame_compile() {
  cd $MAME_SRC_PATH
  make
  rm --recursive --force $MAME_BUILD_PATH
  mkdir --parents $MAME_BUILD_PATH/bin
  cp mame64 $MAME_BUILD_PATH/bin/mame
}

mame_build_package() {
  local dst_dir=$1
  declare_debian_package_dependencies mame $MAME_DEB_DEPENDENCIES
  build_debian_package $MAME_BUILD_PATH mame $MAME_VERSION bin/
  mv mame_${MAME_VERSION}_amd64.deb $dst_dir/

  fpm -C $tmp_dir -s dir -t deb --name mame --version $MAME_VERSION --force $dependencies_args --prefix /usr bin/
  mv mame_${MAME_VERSION}_amd64.deb $dst_dir/
  rm --recursive $tmp_dir
}

mame_install_package() {
  install_packages $MAME_DEB_DEPENDENCIES
  install_package_from_url $MAME_DEB_URL mame
}
