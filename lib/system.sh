# Update the system using apt-get
update_system() {
  DEBIAN_FRONTEND=noninteractive apt-get --assume-yes update
  # DEBIAN_FRONTEND=noninteractive apt-get --assume-yes upgrade
}

# Restart the system
reboot() {
  shutdown -r now
}

# Install a list a packages using apt-get
install_packages() {
  local packages=$@
  DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install $packages
}

# Alias for `install_packages` with only one package
install_package() {
  local package=$1
  install_packages $package
}

install_package_from_url() {
  local url=$1
  local name=$2
  if ! dpkg --status $name &> /dev/null; then
    rm --recursive --force /tmp/remote_package
    mkdir /tmp/remote_package
    cd /tmp/remote_package
    curl --remote-name --location $url
    dpkg -i *.deb
  fi
  }

# Create a user on the system
create_user() {
  local username=$1
  useradd --comment "$username cab user" --home /home/$username --create-home --shell /bin/bash $username
}

# Auto login an user on startup
login_on_startup_user() {
  local username=$1
  replace_config_line "1:2345:respawn:/sbin/getty 38400 tty1" "#1:2345:respawn:/sbin/getty 38400 tty1" /etc/inittab
  add_new_config_line_under "#1:2345:respawn:/sbin/getty 38400 tty1" "1:2345:respawn:/bin/login -f $username tty1 </dev/tty1 >/dev/tty1 2>&1" /etc/inittab
}

# Start X when the user login
startx_on_login() {
  local user=$1
  add_config_line "startx" "/home/$user/.profile"
}

start_on_startx() {
  local user=$1
  local cmd=$2
  add_config_line "attract" "/home/$user/.xinitrc"
}

# Add module names to the list of modules loaded by initframfs
# and update the existing instance
enable_initramfs_modules() {
  local modules=$@
  for module in $modules; do
    add_config_line $module /etc/initramfs-tools/modules
  done
  update-initramfs -u
}

# Alias for `enable_initramfs_modules` with only one module
enable_initramfs_module() {
  local module=$1
  enable_initramfs_modules $module
}

# Set the graphic resolution for grub
set_grub_resolution() {
  local resolution=$1
  add_config_line "GRUB_GFXMODE=$resolution" /etc/default/grub
  update-grub2
}

# Configure for how long the grub menu is show at startup
set_grub_timeout() {
  local timeout=$1
  replace_config_line "GRUB_TIMEOUT=" "GRUB_TIMEOUT=0" "/etc/grub/default"
  update-grub
}

# Enable splash screen in grub
enable_grub_splash_screen() {
  replace_config_line "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet\"" "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"" /etc/default/grub
  update-grub2
}

# Install and configure a splash screen using plymouth
setup_bootsplash() {
  local plymouth_theme=$1
  local resolution=$2
  install_package plymouth
  /usr/sbin/plymouth-set-default-theme $plymouth_theme
  enable_initramfs_modules "drm" "nouveau modeset=1"
  set_grub_resolution $resolution
  enable_grub_splash_screen
}

# Install and configure xorg for the cab user
setup_x_server() {
  local user=$1
  local resolution=$2
  local keyboard=$3
  install_package xorg
  add_config_line "xrandr -s $resolution # Set the screen resolution" /home/$user/.xinitrc
  add_config_line "setxkbmap -layout $keyboard # Set the keyboard layout" /home/$user/.xinitrc
  add_config_line "xset s off # Disable the screensaver" /home/$user/.xinitrc
  add_config_line "xset -dpms # Turn off power management" /home/$user/.xinitrc
}

# Install and configure alsa
# TODO: setup default volume on Master
setup_audio() {
  install_packages alsa-oss alsa-utils
}
