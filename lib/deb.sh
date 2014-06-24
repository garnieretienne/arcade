source "$(dirname $BASH_SOURCE)/system.sh"

ensure_fpm_is_installed() {
  if ! which fpm &> /dev/null; then
    echo "Install dependencies to build debian packages"
    install_package ruby-dev
    echo "Install FPM gem"
    gem install fpm
  fi
}

declare_debian_package_dependencies() {
  local package=$1
  local dependencies=${@:2}
  CURRENT_PACKAGE_NAME=$package
  CURRENT_PACKAGE_DEPENDENCIES=$dependencies
}

build_debian_package() {
  local build_folder=$1
  local name=$2
  local version=$3
  local folders=${@:4}
  local dependencies_args=""

  echo "Build debian package '$name' ($version)"

  if [[ "$CURRENT_PACKAGE_NAME" -eq "$name" ]]; then
    dependencies_args=$(for pkg in $CURRENT_PACKAGE_DEPENDENCIES; do printf " --depends $pkg"; done)
  fi

  ensure_fpm_is_installed
  fpm -C $build_folder -s dir -t deb --name $name --version $version --force \
      --prefix /usr $dependencies_args $folders
}
