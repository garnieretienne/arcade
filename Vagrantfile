# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ffuenf/debian-7.5.0-amd64"

  # Upgrade the memory
  config.vm.provider("virtualbox"){|vb| vb.memory = 1024}

  # Get access to sources
  config.vm.synced_folder ".", "/vagrant"

  # Default VM use 'mirrors.kernel.org' as main address but it's damn slow or
  # offline at my location. Replace with 'ftp.debian.org' address.
  replace_source_url = <<-SCRIPT
cat > /etc/apt/sources.list <<-APT
  deb http://ftp.debian.org/debian wheezy main
  deb-src http://ftp.debian.org/debian wheezy main
  deb http://security.debian.org/ wheezy/updates main
  deb-src http://security.debian.org/ wheezy/updates main
  deb http://ftp.debian.org/debian wheezy-updates main
  deb-src http://ftp.debian.org/debian wheezy-updates main
APT
  SCRIPT

  # Main arcade host
  config.vm.define "arcade", primary: true do |arcade|

    # Get access to roms sample
    config.vm.synced_folder "./sample", "/usr/share/arcade"

    # Don't boot with headless mode
    arcade.vm.provider("virtualbox"){|vb| vb.gui = true}

    # Bootstrap the VM
    arcade.vm.provision "shell", inline: replace_source_url, privileged: true
    arcade.vm.provision "shell", path: "bootstrap", privileged: true,
        keep_color: true
  end

  # Host used to build the MAME deb package
  config.vm.define "build_mame_package", autostart: false do |mamedeb|

    # Script used to build MAME package
    build_mame = <<-SCRIPT
      cd /vagrant
      source lib/mame.sh
      update_system
      mame_install_build_dependencies
      mame_download_sources
      mame_compile
      mame_build_package /vagrant/deb
      echo ""
      echo "MAME debian package created ('deb/$(ls /vagrant/deb/ | grep mame)')"
    SCRIPT

    # Download, compile and package MAME
    mamedeb.vm.provision "shell", inline: replace_source_url, privileged: true
    mamedeb.vm.provision "shell", inline: build_mame, privileged: true
  end

  # Host used to build the SFML deb package
  config.vm.define "build_sfml_packages", autostart: false do |sfmldeb|

    # Script used to build SFML libraries packages
    build_sfml = <<-SCRIPT
      cd /vagrant
      source lib/sfml2.sh
      update_system
      sfml_install_build_dependencies
      sfml_download_sources
      sfml_compile
      sfml_build_package /vagrant/deb
      echo ""
      echo "SFML debian packages created:"
      for pkg in $(ls /vagrant/deb/ | grep libsfml); do
        echo "- $pkg"
      done
    SCRIPT

    # Download, compile and package SFML
    sfmldeb.vm.provision "shell", inline: replace_source_url, privileged: true
    sfmldeb.vm.provision "shell", inline: build_sfml, privileged: true
  end

  # Host used to build the attract-mode deb package
  config.vm.define "build_attract_package", autostart: false do |attractdeb|

    # Script used to build the attract-mode package
    build_attract = <<-SCRIPT
      cd /vagrant
      source lib/attract.sh
      update_system
      attract_install_build_dependencies
      attract_download_sources
      attract_compile
      attract_build_package /vagrant/deb
      echo ""
      echo "Attract-mode debian package created ('deb/$(ls /vagrant/deb/ | grep attract)')"
    SCRIPT

    # Download, compile and package attract-mode
    attractdeb.vm.provision "shell", inline: replace_source_url, privileged: true
    attractdeb.vm.provision "shell", inline: build_attract, privileged: true
  end

  # Host used to build the retroarch deb package
  config.vm.define "build_retroarch_package", autostart: false do |retroarchdeb|

    # Script used to build the retroarch package
    build_retroarch = <<-SCRIPT
      cd /vagrant
      source lib/retroarch.sh
      update_system
      retroarch_install_build_dependencies
      retroarch_download_sources
      retroarch_compile
      retroarch_build_package /vagrant/deb
      echo ""
      echo "Retroarch debian package created ('deb/$(ls /vagrant/deb/ | grep retroarch)')"
    SCRIPT

    # Download, compile and package attract-mode
    retroarchdeb.vm.provision "shell", inline: replace_source_url, privileged: true
    retroarchdeb.vm.provision "shell", inline: build_retroarch, privileged: true
  end

  # Host used to build the snes9x deb package
  config.vm.define "build_snes9x_package", autostart: false do |snes9xdeb|

    # Script used to build the snes9x package
    build_snes9x = <<-SCRIPT
      cd /vagrant
      source lib/snes9x.sh
      update_system
      snes9x_install_build_dependencies
      snes9x_download_sources
      snes9x_compile
      snes9x_build_package /vagrant/deb
      echo ""
      echo "Libretro SNES9X core debian package created ('deb/$(ls /vagrant/deb/ | grep snes9x)')"
    SCRIPT

    # Download, compile and package snes9x
    snes9xdeb.vm.provision "shell", inline: replace_source_url, privileged: true
    snes9xdeb.vm.provision "shell", inline: build_snes9x, privileged: true
  end
end
