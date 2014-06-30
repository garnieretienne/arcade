source "$(dirname $BASH_SOURCE)/system.sh"
source "$(dirname $BASH_SOURCE)/utils.sh"
source "$(dirname $BASH_SOURCE)/deb.sh"

readonly MAME_DEB_URL="file://$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../deb/mame_0.153_amd64.deb"
readonly MAME_FILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../files/mame"

readonly MAME_SRC_URL="http://mame.mirrors.zippykid.com/releases/mame0153s.zip"
readonly MAME_VERSION="0.153"
readonly MAME_SRC_PATH="/usr/local/src/mame_${MAME_VERSION}"
readonly MAME_BUILD_PATH="/tmp/mame_build"
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
}

mame_install_package() {
  install_packages $MAME_DEB_DEPENDENCIES
  install_package_from_url $MAME_DEB_URL mame
}

# Generate a default `mame.ini` file and display it to stdout
# Changes in the default mame configuration:
# * update core output directory path
# * update rom path
# * enable opengl
# * enable multithreading
mame_generate_config() {
  local rom_path=$1
  cd /tmp
  mame -createconfig &> /dev/null
  replace_config_line "multithreading" "multithreading 1" "/tmp/mame.ini"
  replace_config_line "video" "video opengl" "/tmp/mame.ini"
  replace_config_line "cfg_directory" 'cfg_directory $HOME/.mame/cfg' "/tmp/mame.ini"
  replace_config_line "nvram_directory" 'nvram_directory $HOME/.mame/nvram' "/tmp/mame.ini"
  replace_config_line "memcard_directory" 'memcard_directory $HOME/.mame/memcard' "/tmp/mame.ini"
  replace_config_line "input_directory" 'input_directory $HOME/.mame/inp' "/tmp/mame.ini"
  replace_config_line "state_directory" 'state_directory $HOME/.mame/sta' "/tmp/mame.ini"
  replace_config_line "snapshot_directory" 'snapshot_directory $HOME/.mame/snap' "/tmp/mame.ini"
  replace_config_line "diff_directory" 'diff_directory $HOME/.mame/diff' "/tmp/mame.ini"
  replace_config_line "comment_directory" 'comment_directory $HOME/.mame/comments' "/tmp/mame.ini"
  replace_config_line "ctrlrpath" 'ctrlrpath $HOME/.mame/ctrlr' "/tmp/mame.ini"
  replace_config_line "rompath" "rompath $rom_path" "/tmp/mame.ini"
  cat mame.ini
}

mame_generate_controls_config() {
  cat $MAME_FILES_DIR/default.cfg
}
