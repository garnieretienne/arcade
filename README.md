This repo contain a collection of bash scripts and libraries used to bootstrap
an untouched arcade system from a Debian 7 64 Bits

# Getting started

Using a root session, run the following commands:
```
sudo apt-get install git curl
git clone [insert repo URI here]
cd arcade
./bootstrap
```

You can also use "tools" script to manage emulators, roms and frontend.
Example: Installing `mame` emulator from the debian package (must be generated
or downloaded previously).

```
./mame-tools --install-package
```

# Missing packages

The frontend ([Attract-Mode](http://attractmode.org/)) used in this setup is not
present in the debian repositories. You can download, compile and package it
using Vagrant and booting the `build_attract_package` VM, but you must first
build the [SFML2](http://www.sfml-dev.org/) libraries using the
`build_sfml_package` VM.

```
vagrant up build_sfml_packages
# ...
# Vagrant boot the VM and start the init script.
# The init script download and compile SFML sources and build a debian package.
# If the script success, the debian package will be in the `deb/` folder.
# ...
vagrant up build_attract_package
# ...
# Same, download, compile amd package the `attract` package in the `deb/`
# folder.
# ...
```

# Build MAME debian package using the vagrant host

You can use the `vagrant up build_mame_package` command to create a debian
package for mame in `deb/`.

__Note: This can take a long time to compile, like many hours.__
