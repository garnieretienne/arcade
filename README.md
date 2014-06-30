This repo contains a collection of bash scripts and libraries used to bootstrap
an arcade system from a fresh Debian 7 (x64).

What do the script do:
* Update the system (`apt-get update`)
* Install and configure plymouth to have a boosplash image
* Create an `arcade` user and auto log it at boot
* Install xorg and start X when `arcade` user log in
* Install alsa audio packages and try to unmutte sound
* Install and configure the Attract-Mode emulator frontend (using packages in
  the `deb/` folder)
* Install and configure MAME (v0.153) to run roms located in
  `/usr/share/arcade/arcade/roms` and using snapshots if present in
  `/usr/share/arcade/arcade/snapshots` (using packages from the `deb/` folder).

# Getting started

## Dependencies

* You **must** have `curl` and `git` installed.
* You **must** have your mame romset for v0.153 in /usr/share/arcade/arcade/roms
* You **can** have your mame games snapshots in /usr/share/arcade/arcade/snapshots

## Clone the repository

```
git clone https://github.com/garnieretienne/arcade.git
cd arcade
```

## Build missing packages

We will need some missing packages in the `deb/` directory in order to continue
the installation.

### SFML2

[SFML](http://www.sfml-dev.org/index.php) is a multimedia library needed by
the [Attract-Mode](http://attractmode.org/) frontend.

Build the SFML2 debian package using vagrant: `vagrant up build_sfml_packages`.
You should now have the `libsfml_2.1_amd64.deb` amd `libsfml-dev_2.1_amd64.deb`
packages in the `deb/` repository.

### Attract-Mode

[Attract-Mode](http://attractmode.org/) is an emulator frontend.

Build the Attract-Mode debian package using vagrant:
`vagrant up build_attract_package`.
You should now have the `attract-mode_1.3.1_amd64.deb` package in the `deb/`
repository.

### MAME

[MAME](http://mamedev.org/) is an arcade machine emulator.

Build the MAME debian package using vagrant: `vagrant up build_mame_package`.
You should now have the `mame_0.153_amd64.deb` package in the `deb/` repository.

## Bootstrap

**As root (or using sudo)** start the `./bootstrap` script to install and
configure everything.

Sample output:
```
root@arcade:/home/kurt/arcade# ./bootstrap
>> Updating the system...
   Update the system
   Hit http://debian.proxad.net wheezy Release.gpg
   ...
   Hit http://debian.proxad.net wheezy-updates/main Translation-en/DiffIndex
   Reading package lists...
>> Configuring bootsplash on the system...
   Build the 'arcade' plymouth theme using the './artwork/bootloader.png' image
   Setup the 'arcade' bootsplash
   Install package(s): plymouth plymouth-drm
   Reading package lists...
   Building dependency tree...
   Reading state information...
   The following extra packages will be installed:
   fontconfig fontconfig-config libcairo2 libdatrie1 libdrm2 libffi5
   libfontconfig1 libglib2.0-0 libglib2.0-data libkms1 libpango1.0-0
   libpixman-1-0 libpng12-0 libthai-data libthai0 libxcb-render0 libxcb-shm0
   libxft2 libxrender1 plymouth-themes-all plymouth-themes-fade-in
   plymouth-themes-glow plymouth-themes-script plymouth-themes-solar
   plymouth-themes-spinfinity plymouth-themes-spinner shared-mime-info
   ttf-dejavu-core
   Suggested packages:
   ttf-baekmuk ttf-arphic-gbsn00lp ttf-arphic-bsmi00lp ttf-arphic-gkai00mp
   ttf-arphic-bkai00mp desktop-base
   The following NEW packages will be installed:
   fontconfig fontconfig-config libcairo2 libdatrie1 libdrm2 libffi5
   libfontconfig1 libglib2.0-0 libglib2.0-data libkms1 libpango1.0-0
   libpixman-1-0 libpng12-0 libthai-data libthai0 libxcb-render0 libxcb-shm0
   libxft2 libxrender1 plymouth plymouth-drm plymouth-themes-all
   plymouth-themes-fade-in plymouth-themes-glow plymouth-themes-script
   plymouth-themes-solar plymouth-themes-spinfinity plymouth-themes-spinner
   shared-mime-info ttf-dejavu-core
   0 upgraded, 30 newly installed, 0 to remove and 0 not upgraded.
   Need to get 10.1 MB of archives.
   After this operation, 27.9 MB of additional disk space will be used.
   Get:1 http://debian.proxad.net/debian/ wheezy/main ttf-dejavu-core all 2.33-3 [1,021 kB]
   ...
   Get:30 http://debian.proxad.net/debian/ wheezy/main shared-mime-info amd64 1.0-1+b1 [595 kB]
   Preconfiguring packages ...
   Fetched 10.1 MB in 10s (994 kB/s)
   Selecting previously unselected package ttf-dejavu-core.
(Reading database ... 27045 files and directories currently installed.)
   Unpacking ttf-dejavu-core (from .../ttf-dejavu-core_2.33-3_all.deb) ...
   Selecting previously unselected package fontconfig-config.
   ...
   Unpacking plymouth-themes-all (from .../plymouth-themes-all_0.8.5.1-5_all.deb) ...
   Selecting previously unselected package shared-mime-info.
   Unpacking shared-mime-info (from .../shared-mime-info_1.0-1+b1_amd64.deb) ...
   Processing triggers for man-db ...
   Setting up ttf-dejavu-core (2.33-3) ...
   ...
   Setting up shared-mime-info (1.0-1+b1) ...
   Processing triggers for initramfs-tools ...
   update-initramfs: Generating /boot/initrd.img-3.2.0-4-amd64
   Add module(s) to be loaded by initramfs: drm nouveau modeset=1
   update-initramfs: Generating /boot/initrd.img-3.2.0-4-amd64
   Set grub resolution to '1024x768'
 ! Generating grub.cfg ...
 ! Found linux image: /boot/vmlinuz-3.2.0-4-amd64
 ! Found initrd image: /boot/initrd.img-3.2.0-4-amd64
 ! done
   Enable splash screen in grub
 ! Generating grub.cfg ...
 ! Found linux image: /boot/vmlinuz-3.2.0-4-amd64
 ! Found initrd image: /boot/initrd.img-3.2.0-4-amd64
 ! done
   Set grub timeout to '0'
 ! Generating grub.cfg ...
 ! Found linux image: /boot/vmlinuz-3.2.0-4-amd64
 ! Found initrd image: /boot/initrd.img-3.2.0-4-amd64
 ! done
>> Configuring main user on the system...
   Create user 'arcade'
   Log in user 'arcade' on startup
   Setup X server
   Install package(s): xorg
   Reading package lists...
   Building dependency tree...
   Reading state information...
   The following extra packages will be installed:
   cpp cpp-4.7 libaudit0 libdrm-intel1 libdrm-nouveau1a libdrm-radeon1
   libfontenc1 libfs6 libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa
   libglu1-mesa libgmp10 libice6 libmpc2 libmpfr4 libmtdev1 libpciaccess0
   libsm6 libutempter0 libx11-xcb1 libxaw7 libxcb-dri2-0 libxcb-glx0
   libxcb-shape0 libxcb-util0 libxcomposite1 libxcursor1 libxdamage1 libxfixes3
   libxfont1 libxi6 libxinerama1 libxkbfile1 libxmu6 libxpm4 libxrandr2 libxt6
   libxtst6 libxv1 libxvmc1 libxxf86dga1 libxxf86vm1 x11-apps x11-common
   x11-session-utils x11-utils x11-xfs-utils x11-xkb-utils x11-xserver-utils
   xbitmaps xfonts-100dpi xfonts-75dpi xfonts-base xfonts-encodings
   xfonts-scalable xfonts-utils xinit xorg-docs-core xserver-common
   xserver-xorg xserver-xorg-core xserver-xorg-input-all
   xserver-xorg-input-evdev xserver-xorg-input-mouse
   xserver-xorg-input-synaptics xserver-xorg-input-vmmouse
   xserver-xorg-input-wacom xserver-xorg-video-all xserver-xorg-video-apm
   xserver-xorg-video-ark xserver-xorg-video-ati xserver-xorg-video-chips
   xserver-xorg-video-cirrus xserver-xorg-video-fbdev xserver-xorg-video-i128
   xserver-xorg-video-intel xserver-xorg-video-mach64 xserver-xorg-video-mga
   xserver-xorg-video-neomagic xserver-xorg-video-nouveau
   xserver-xorg-video-openchrome xserver-xorg-video-r128
   xserver-xorg-video-radeon xserver-xorg-video-rendition xserver-xorg-video-s3
   xserver-xorg-video-s3virge xserver-xorg-video-savage
   xserver-xorg-video-siliconmotion xserver-xorg-video-sis
   xserver-xorg-video-sisusb xserver-xorg-video-tdfx xserver-xorg-video-trident
   xserver-xorg-video-tseng xserver-xorg-video-vesa xserver-xorg-video-vmware
   xserver-xorg-video-voodoo xterm
   Suggested packages:
   cpp-doc gcc-4.7-locales libglide3 mesa-utils nickle cairo-5c xfs xserver
   xorg-docs gpointing-device-settings touchfreeze xinput firmware-linux
   xfonts-cyrillic
   The following NEW packages will be installed:
   cpp cpp-4.7 libaudit0 libdrm-intel1 libdrm-nouveau1a libdrm-radeon1
   libfontenc1 libfs6 libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa
   libglu1-mesa libgmp10 libice6 libmpc2 libmpfr4 libmtdev1 libpciaccess0
   libsm6 libutempter0 libx11-xcb1 libxaw7 libxcb-dri2-0 libxcb-glx0
   libxcb-shape0 libxcb-util0 libxcomposite1 libxcursor1 libxdamage1 libxfixes3
   libxfont1 libxi6 libxinerama1 libxkbfile1 libxmu6 libxpm4 libxrandr2 libxt6
   libxtst6 libxv1 libxvmc1 libxxf86dga1 libxxf86vm1 x11-apps x11-common
   x11-session-utils x11-utils x11-xfs-utils x11-xkb-utils x11-xserver-utils
   xbitmaps xfonts-100dpi xfonts-75dpi xfonts-base xfonts-encodings
   xfonts-scalable xfonts-utils xinit xorg xorg-docs-core xserver-common
   xserver-xorg xserver-xorg-core xserver-xorg-input-all
   xserver-xorg-input-evdev xserver-xorg-input-mouse
   xserver-xorg-input-synaptics xserver-xorg-input-vmmouse
   xserver-xorg-input-wacom xserver-xorg-video-all xserver-xorg-video-apm
   xserver-xorg-video-ark xserver-xorg-video-ati xserver-xorg-video-chips
   xserver-xorg-video-cirrus xserver-xorg-video-fbdev xserver-xorg-video-i128
   xserver-xorg-video-intel xserver-xorg-video-mach64 xserver-xorg-video-mga
   xserver-xorg-video-neomagic xserver-xorg-video-nouveau
   xserver-xorg-video-openchrome xserver-xorg-video-r128
   xserver-xorg-video-radeon xserver-xorg-video-rendition xserver-xorg-video-s3
   xserver-xorg-video-s3virge xserver-xorg-video-savage
   xserver-xorg-video-siliconmotion xserver-xorg-video-sis
   xserver-xorg-video-sisusb xserver-xorg-video-tdfx xserver-xorg-video-trident
   xserver-xorg-video-tseng xserver-xorg-video-vesa xserver-xorg-video-vmware
   xserver-xorg-video-voodoo xterm
   0 upgraded, 99 newly installed, 0 to remove and 0 not upgraded.
   Need to get 56.8 MB of archives.
   After this operation, 155 MB of additional disk space will be used.
   Get:1 http://debian.proxad.net/debian/ wheezy/main libpciaccess0 amd64 0.13.1-2 [46.7 kB]
   ...
   Get:99 http://debian.proxad.net/debian/ wheezy/main xorg amd64 1:7.7+3~deb7u1 [36.7 kB]
Extracting templates from packages: 100%
   Preconfiguring packages ...
   Fetched 56.8 MB in 53s (1,067 kB/s)
   Selecting previously unselected package libpciaccess0:amd64.
(Reading database ... 27777 files and directories currently installed.)
   Unpacking libpciaccess0:amd64 (from .../libpciaccess0_0.13.1-2_amd64.deb) ...
   Selecting previously unselected package libdrm-intel1:amd64.
   ...
   Selecting previously unselected package xorg.
   Unpacking xorg (from .../xorg_1%3a7.7+3~deb7u1_amd64.deb) ...
   Processing triggers for man-db ...
   Processing triggers for fontconfig ...
   Setting up libpciaccess0:amd64 (0.13.1-2) ...
   ...
   Setting up xserver-xorg-input-wacom (0.15.0+20120515-2) ...
   Setting up xserver-xorg (1:7.7+3~deb7u1) ...
   Setting up xorg-docs-core (1:1.6-1) ...
   Setting up xterm (278-4) ...
   update-alternatives: using /usr/bin/xterm to provide /usr/bin/x-terminal-emulator (x-terminal-emulator) in auto mode
   update-alternatives: using /usr/bin/uxterm to provide /usr/bin/x-terminal-emulator (x-terminal-emulator) in auto mode
   update-alternatives: using /usr/bin/lxterm to provide /usr/bin/x-terminal-emulator (x-terminal-emulator) in auto mode
   Setting up xorg (1:7.7+3~deb7u1) ...
   Start X on user 'arcade' login
>> Configuring audio on the system...
   Setup audio
   Install package(s): alsa-oss alsa-utils oss-compat
   Reading package lists...
   Building dependency tree...
   Reading state information...
   The following extra packages will be installed:
   alsa-base libasound2 libsamplerate0
   Suggested packages:
   libasound2-plugins
   The following NEW packages will be installed:
   alsa-base alsa-oss alsa-utils libasound2 libsamplerate0 oss-compat
   0 upgraded, 6 newly installed, 0 to remove and 0 not upgraded.
   Need to get 3,089 kB of archives.
   After this operation, 5,226 kB of additional disk space will be used.
   Get:1 http://debian.proxad.net/debian/ wheezy/main alsa-base all 1.0.25+3~deb7u1 [61.1 kB]
   ...
   Get:6 http://debian.proxad.net/debian/ wheezy/main oss-compat amd64 2 [4,620 B]
   Fetched 3,089 kB in 2s (1,041 kB/s)
   Selecting previously unselected package alsa-base.
(Reading database ... 30222 files and directories currently installed.)
   Unpacking alsa-base (from .../alsa-base_1.0.25+3~deb7u1_all.deb) ...
   Selecting previously unselected package libasound2:amd64.
   ...
   Selecting previously unselected package oss-compat.
   Unpacking oss-compat (from .../oss-compat_2_amd64.deb) ...
   Processing triggers for man-db ...
   Setting up alsa-base (1.0.25+3~deb7u1) ...
   ...
   Setting up oss-compat (2) ...
   Simple mixer control 'Master',0
   Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
   Playback channels: Mono
   Limits: Playback 0 - 31
   Mono: Playback 16 [52%] [-22.50dB] [on]
 ! amixer: Unable to find simple control 'PCM',0
 !
   Simple mixer control 'Front',0
   Capabilities: pvolume pswitch penum
   Playback channels: Front Left - Front Right
   Limits: Playback 0 - 31
   Mono:
   Front Left: Playback 31 [100%] [0.00dB] [on]
   Front Right: Playback 31 [100%] [0.00dB] [on]
>> Configuring emulator frontend on the system...
   Install package 'libsfml' from 'file:///home/kurt/arcade/lib/../deb/libsfml_2.1_amd64.deb'
######################################################################## 100.0%
   Selecting previously unselected package libsfml.
   (Reading database ... 30418 files and directories currently installed.)
   Unpacking libsfml (from libsfml_2.1_amd64.deb) ...
   Setting up libsfml (2.1) ...
   Install package(s): libsfml libavformat53 libswscale2 libopenal1 libglew1.7 libjpeg8 libxrandr2 ttf-freefont
   Reading package lists...
   Building dependency tree...
   Reading state information...
   libxrandr2 is already the newest version.
   libxrandr2 set to manually installed.
   libsfml is already the newest version.
   The following extra packages will be installed:
   dbus fonts-freefont-ttf libasyncns0 libavcodec53 libavutil51 libdbus-1-3
   libdirac-encoder0 libflac8 libgsm1 libjson0 libmp3lame0 libogg0
   libopenal-data libopenjpeg2 liborc-0.4-0 libpulse0 libschroedinger-1.0-0
   libsndfile1 libspeex1 libsystemd-login0 libtheora0 libva1 libvorbis0a
   libvorbisenc2 libvpx1 libx264-123 libxvidcore4
   Suggested packages:
   dbus-x11 glew-utils libportaudio2 libroar-compat2 pulseaudio speex
   The following NEW packages will be installed:
   dbus fonts-freefont-ttf libasyncns0 libavcodec53 libavformat53 libavutil51
   libdbus-1-3 libdirac-encoder0 libflac8 libglew1.7 libgsm1 libjpeg8 libjson0
   libmp3lame0 libogg0 libopenal-data libopenal1 libopenjpeg2 liborc-0.4-0
   libpulse0 libschroedinger-1.0-0 libsndfile1 libspeex1 libswscale2
   libsystemd-login0 libtheora0 libva1 libvorbis0a libvorbisenc2 libvpx1
   libx264-123 libxvidcore4 ttf-freefont
   0 upgraded, 33 newly installed, 0 to remove and 0 not upgraded.
   Need to get 14.3 MB of archives.
   After this operation, 35.5 MB of additional disk space will be used.
   Get:1 http://debian.proxad.net/debian/ wheezy/main libasyncns0 amd64 0.8-4 [13.6 kB]
   ...
   Get:33 http://debian.proxad.net/debian/ wheezy/main ttf-freefont all 20120503-1 [118 kB]
Extracting templates from packages: 100%
   Fetched 14.3 MB in 12s (1,129 kB/s)
   Selecting previously unselected package libasyncns0:amd64.
(Reading database ... 30464 files and directories currently installed.)
   Unpacking libasyncns0:amd64 (from .../libasyncns0_0.8-4_amd64.deb) ...
   Selecting previously unselected package libavutil51:amd64.
   ...
   Unpacking ttf-freefont (from .../ttf-freefont_20120503-1_all.deb) ...
   Processing triggers for man-db ...
   Processing triggers for fontconfig ...
   Setting up libasyncns0:amd64 (0.8-4) ...
   ...
   Setting up dbus (1.6.8-1+deb7u1) ...
[ ok ...] Starting system message bus: dbus.
   Setting up fonts-freefont-ttf (20120503-1) ...
   Setting up ttf-freefont (20120503-1) ...
   Install package 'attract-mode' from 'file:///home/kurt/arcade/lib/../deb/attract-mode_1.3.1_amd64.deb'
######################################################################## 100.0%
   Selecting previously unselected package attract-mode.
   (Reading database ... 30742 files and directories currently installed.)
   Unpacking attract-mode (from attract-mode_1.3.1_amd64.deb) ...
   Setting up attract-mode (1.3.1) ...
   Generate attract config file
   Start the 'attract' command when X start on user 'arcade'
>> Configuring MAME emulator on the system...
   Install package(s): libasound2 libqtgui4 libsdl1.2debian libsdl-ttf2.0-0 libxinerama1
   Reading package lists...
   Building dependency tree...
   Reading state information...
   libasound2 is already the newest version.
   libasound2 set to manually installed.
   libxinerama1 is already the newest version.
   libxinerama1 set to manually installed.
   The following extra packages will be installed:
   libaudio2 libavahi-client3 libavahi-common-data libavahi-common3 libcaca0
   libcups2 libdirectfb-1.2-9 libjbig0 liblcms1 libmng1 libqtcore4 libtiff4
   libts-0.0-0 tsconf
   Suggested packages:
   nas cups-common liblcms-utils libicu48 qt4-qtconfig
   The following NEW packages will be installed:
   libaudio2 libavahi-client3 libavahi-common-data libavahi-common3 libcaca0
   libcups2 libdirectfb-1.2-9 libjbig0 liblcms1 libmng1 libqtcore4 libqtgui4
   libsdl-ttf2.0-0 libsdl1.2debian libtiff4 libts-0.0-0 tsconf
   0 upgraded, 17 newly installed, 0 to remove and 0 not upgraded.
   Need to get 9,207 kB of archives.
   After this operation, 29.4 MB of additional disk space will be used.
   Get:1 http://debian.proxad.net/debian/ wheezy/main libaudio2 amd64 1.9.3-5wheezy1 [87.1 kB]
   ...
   Get:17 http://debian.proxad.net/debian/ wheezy/main libsdl-ttf2.0-0 amd64 2.0.11-2 [20.4 kB]
   Fetched 9,207 kB in 8s (1,075 kB/s)
   Selecting previously unselected package libaudio2:amd64.
(Reading database ... 30794 files and directories currently installed.)
   Unpacking libaudio2:amd64 (from .../libaudio2_1.9.3-5wheezy1_amd64.deb) ...
   Selecting previously unselected package libavahi-common-data:amd64.
   ...
   Selecting previously unselected package libsdl-ttf2.0-0:amd64.
   Unpacking libsdl-ttf2.0-0:amd64 (from .../libsdl-ttf2.0-0_2.0.11-2_amd64.deb) ...
   Processing triggers for man-db ...
   Setting up libaudio2:amd64 (1.9.3-5wheezy1) ...
   ...
   Setting up libsdl-ttf2.0-0:amd64 (2.0.11-2) ...
   Install package 'mame' from 'file:///home/kurt/arcade/lib/../deb/mame_0.153_amd64.deb'
######################################################################## 100.0%
   Selecting previously unselected package mame.
   (Reading database ... 31095 files and directories currently installed.)
   Unpacking mame (from mame_0.153_amd64.deb) ...
   Setting up mame (0.153) ...
   Generate mame config files
   Generate attract config file for mame emulator
   Generate attract list entry for the arcade rom list
   Generate the arcade rom list
   Found 9002 files with rom extension(s): .zip .7z <DIR>.  Directory: /usr/share/arcade/arcade/roms/
   Obtaining -listxml info...100%
   Discarded 92 entries based on xml info: 3dobios acpsx airlbios aleck64 alg_bios allied ar_bios aristmk5 aristmk6 atarisy1 atluspsx atpsx awbios bubsys cd32bios cdibios chihiro cpzn1 cpzn2 crysbios decocass f355bios galgbios gp_110 gq863 gts1 gts1s hikaru hng64 hod2bios isgsm iteagle konamigv konamigx kviper macsbios maxaflex megaplay megatech mk6nsw11 naomi naomi2 naomigd neogeo nss pgm playch10 psarc95 pyson sammymdl sfcbox shtzone skns stvbios su2000 sys246 sys256 sys573 taitofx1 taitogn taitotz tourvis tps triforce v4bios vspsx mie qsound bsmt2000 ldv1000 namco51 hd61830 namco50 namco52 namco54 pr8210 midssio tms32032 tms32031 simutrek k573mcr k573dio namco53 k573msu filetto_cga tetriskr_cga 22vp931 namco62 ym2608 k573npu saa5050 m50458
   Removing any duplicate entries...
   Writing 8910 entries to: /home/arcade/.attract/romlists/arcade.txt
>> Done.
   Restart the system
```

# Artwork

* Bootloader image: [Bad Company by Kaiseto](http://kaiseto.deviantart.com/art/Bad-Company-128055448)