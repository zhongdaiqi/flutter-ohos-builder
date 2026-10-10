# CI diagnostics

run: 38078183585  sha: 0256100cb9bb801e62261cede8e0b9474c42f02d
time: 2026-10-10T19:09:52Z

## build outcome: success
## probe outcome: success

## build.log (last 500 lines)
```
#7 9.707 Selecting previously unselected package libegl1:amd64.
#7 9.708 Preparing to unpack .../066-libegl1_1.4.0-1_amd64.deb ...
#7 9.709 Unpacking libegl1:amd64 (1.4.0-1) ...
#7 9.720 Selecting previously unselected package libxcb-glx0:amd64.
#7 9.722 Preparing to unpack .../067-libxcb-glx0_1.14-3ubuntu3_amd64.deb ...
#7 9.722 Unpacking libxcb-glx0:amd64 (1.14-3ubuntu3) ...
#7 9.732 Selecting previously unselected package libxcb-shm0:amd64.
#7 9.734 Preparing to unpack .../068-libxcb-shm0_1.14-3ubuntu3_amd64.deb ...
#7 9.735 Unpacking libxcb-shm0:amd64 (1.14-3ubuntu3) ...
#7 9.745 Selecting previously unselected package libxfixes3:amd64.
#7 9.746 Preparing to unpack .../069-libxfixes3_1%3a6.0.0-1_amd64.deb ...
#7 9.747 Unpacking libxfixes3:amd64 (1:6.0.0-1) ...
#7 9.757 Selecting previously unselected package libxxf86vm1:amd64.
#7 9.758 Preparing to unpack .../070-libxxf86vm1_1%3a1.1.4-1build3_amd64.deb ...
#7 9.759 Unpacking libxxf86vm1:amd64 (1:1.1.4-1build3) ...
#7 9.770 Selecting previously unselected package libllvm15:amd64.
#7 9.772 Preparing to unpack .../071-libllvm15_1%3a15.0.7-0ubuntu0.22.04.3_amd64.deb ...
#7 9.773 Unpacking libllvm15:amd64 (1:15.0.7-0ubuntu0.22.04.3) ...
#7 10.07 Selecting previously unselected package libsensors-config.
#7 10.07 Preparing to unpack .../072-libsensors-config_1%3a3.6.0-7ubuntu1_all.deb ...
#7 10.07 Unpacking libsensors-config (1:3.6.0-7ubuntu1) ...
#7 10.08 Selecting previously unselected package libsensors5:amd64.
#7 10.08 Preparing to unpack .../073-libsensors5_1%3a3.6.0-7ubuntu1_amd64.deb ...
#7 10.09 Unpacking libsensors5:amd64 (1:3.6.0-7ubuntu1) ...
#7 10.10 Selecting previously unselected package libgl1-mesa-dri:amd64.
#7 10.10 Preparing to unpack .../074-libgl1-mesa-dri_23.2.1-1ubuntu3.1~22.04.4_amd64.deb ...
#7 10.16 Unpacking libgl1-mesa-dri:amd64 (23.2.1-1ubuntu3.1~22.04.4) ...
#7 10.27 Selecting previously unselected package libglx-mesa0:amd64.
#7 10.27 Preparing to unpack .../075-libglx-mesa0_23.2.1-1ubuntu3.1~22.04.4_amd64.deb ...
#7 10.27 Unpacking libglx-mesa0:amd64 (23.2.1-1ubuntu3.1~22.04.4) ...
#7 10.28 Selecting previously unselected package libglx0:amd64.
#7 10.28 Preparing to unpack .../076-libglx0_1.4.0-1_amd64.deb ...
#7 10.28 Unpacking libglx0:amd64 (1.4.0-1) ...
#7 10.29 Selecting previously unselected package libgl1:amd64.
#7 10.30 Preparing to unpack .../077-libgl1_1.4.0-1_amd64.deb ...
#7 10.30 Unpacking libgl1:amd64 (1.4.0-1) ...
#7 10.31 Selecting previously unselected package xorg-sgml-doctools.
#7 10.31 Preparing to unpack .../078-xorg-sgml-doctools_1%3a1.11-1.1_all.deb ...
#7 10.31 Unpacking xorg-sgml-doctools (1:1.11-1.1) ...
#7 10.32 Selecting previously unselected package x11proto-dev.
#7 10.32 Preparing to unpack .../079-x11proto-dev_2021.5-1_all.deb ...
#7 10.32 Unpacking x11proto-dev (2021.5-1) ...
#7 10.34 Selecting previously unselected package libxau-dev:amd64.
#7 10.34 Preparing to unpack .../080-libxau-dev_1%3a1.0.9-1build5_amd64.deb ...
#7 10.34 Unpacking libxau-dev:amd64 (1:1.0.9-1build5) ...
#7 10.35 Selecting previously unselected package libxdmcp-dev:amd64.
#7 10.35 Preparing to unpack .../081-libxdmcp-dev_1%3a1.1.3-0ubuntu5_amd64.deb ...
#7 10.35 Unpacking libxdmcp-dev:amd64 (1:1.1.3-0ubuntu5) ...
#7 10.36 Selecting previously unselected package xtrans-dev.
#7 10.36 Preparing to unpack .../082-xtrans-dev_1.4.0-1_all.deb ...
#7 10.37 Unpacking xtrans-dev (1.4.0-1) ...
#7 10.38 Selecting previously unselected package libpthread-stubs0-dev:amd64.
#7 10.38 Preparing to unpack .../083-libpthread-stubs0-dev_0.4-1build2_amd64.deb ...
#7 10.42 Unpacking libpthread-stubs0-dev:amd64 (0.4-1build2) ...
#7 10.43 Selecting previously unselected package libxcb1-dev:amd64.
#7 10.43 Preparing to unpack .../084-libxcb1-dev_1.14-3ubuntu3_amd64.deb ...
#7 10.43 Unpacking libxcb1-dev:amd64 (1.14-3ubuntu3) ...
#7 10.44 Selecting previously unselected package libx11-dev:amd64.
#7 10.44 Preparing to unpack .../085-libx11-dev_2%3a1.7.5-1ubuntu0.3_amd64.deb ...
#7 10.44 Unpacking libx11-dev:amd64 (2:1.7.5-1ubuntu0.3) ...
#7 10.46 Selecting previously unselected package libglx-dev:amd64.
#7 10.46 Preparing to unpack .../086-libglx-dev_1.4.0-1_amd64.deb ...
#7 10.46 Unpacking libglx-dev:amd64 (1.4.0-1) ...
#7 10.47 Selecting previously unselected package libgl-dev:amd64.
#7 10.48 Preparing to unpack .../087-libgl-dev_1.4.0-1_amd64.deb ...
#7 10.48 Unpacking libgl-dev:amd64 (1.4.0-1) ...
#7 10.49 Selecting previously unselected package libegl-dev:amd64.
#7 10.49 Preparing to unpack .../088-libegl-dev_1.4.0-1_amd64.deb ...
#7 10.49 Unpacking libegl-dev:amd64 (1.4.0-1) ...
#7 10.51 Selecting previously unselected package libogg0:amd64.
#7 10.51 Preparing to unpack .../089-libogg0_1.3.5-0ubuntu3_amd64.deb ...
#7 10.51 Unpacking libogg0:amd64 (1.3.5-0ubuntu3) ...
#7 10.52 Selecting previously unselected package libflac8:amd64.
#7 10.52 Preparing to unpack .../090-libflac8_1.3.3-2ubuntu0.2_amd64.deb ...
#7 10.52 Unpacking libflac8:amd64 (1.3.3-2ubuntu0.2) ...
#7 10.53 Selecting previously unselected package libgles1:amd64.
#7 10.53 Preparing to unpack .../091-libgles1_1.4.0-1_amd64.deb ...
#7 10.54 Unpacking libgles1:amd64 (1.4.0-1) ...
#7 10.55 Selecting previously unselected package libgles2:amd64.
#7 10.55 Preparing to unpack .../092-libgles2_1.4.0-1_amd64.deb ...
#7 10.55 Unpacking libgles2:amd64 (1.4.0-1) ...
#7 10.56 Selecting previously unselected package libgles-dev:amd64.
#7 10.56 Preparing to unpack .../093-libgles-dev_1.4.0-1_amd64.deb ...
#7 10.56 Unpacking libgles-dev:amd64 (1.4.0-1) ...
#7 10.57 Selecting previously unselected package libopengl0:amd64.
#7 10.58 Preparing to unpack .../094-libopengl0_1.4.0-1_amd64.deb ...
#7 10.58 Unpacking libopengl0:amd64 (1.4.0-1) ...
#7 10.59 Selecting previously unselected package libopengl-dev:amd64.
#7 10.59 Preparing to unpack .../095-libopengl-dev_1.4.0-1_amd64.deb ...
#7 10.59 Unpacking libopengl-dev:amd64 (1.4.0-1) ...
#7 10.60 Selecting previously unselected package libopus0:amd64.
#7 10.60 Preparing to unpack .../096-libopus0_1.3.1-0.1build2_amd64.deb ...
#7 10.60 Unpacking libopus0:amd64 (1.3.1-0.1build2) ...
#7 10.61 Selecting previously unselected package libvorbis0a:amd64.
#7 10.62 Preparing to unpack .../097-libvorbis0a_1.3.7-1build2_amd64.deb ...
#7 10.62 Unpacking libvorbis0a:amd64 (1.3.7-1build2) ...
#7 10.63 Selecting previously unselected package libvorbisenc2:amd64.
#7 10.63 Preparing to unpack .../098-libvorbisenc2_1.3.7-1build2_amd64.deb ...
#7 10.63 Unpacking libvorbisenc2:amd64 (1.3.7-1build2) ...
#7 10.64 Selecting previously unselected package libsndfile1:amd64.
#7 10.64 Preparing to unpack .../099-libsndfile1_1.0.31-2ubuntu0.2_amd64.deb ...
#7 10.64 Unpacking libsndfile1:amd64 (1.0.31-2ubuntu0.2) ...
#7 10.66 Selecting previously unselected package libpulse0:amd64.
#7 10.66 Preparing to unpack .../100-libpulse0_1%3a15.99.1+dfsg1-1ubuntu2.2_amd64.deb ...
#7 10.66 Unpacking libpulse0:amd64 (1:15.99.1+dfsg1-1ubuntu2.2) ...
#7 10.68 Selecting previously unselected package libxcb-xkb1:amd64.
#7 10.68 Preparing to unpack .../101-libxcb-xkb1_1.14-3ubuntu3_amd64.deb ...
#7 10.68 Unpacking libxcb-xkb1:amd64 (1.14-3ubuntu3) ...
#7 10.69 Selecting previously unselected package libxkbcommon0:amd64.
#7 10.69 Preparing to unpack .../102-libxkbcommon0_1.4.0-1_amd64.deb ...
#7 10.69 Unpacking libxkbcommon0:amd64 (1.4.0-1) ...
#7 10.70 Selecting previously unselected package libxkbcommon-x11-0:amd64.
#7 10.71 Preparing to unpack .../103-libxkbcommon-x11-0_1.4.0-1_amd64.deb ...
#7 10.71 Unpacking libxkbcommon-x11-0:amd64 (1.4.0-1) ...
#7 10.72 Selecting previously unselected package p7zip.
#7 10.72 Preparing to unpack .../104-p7zip_16.02+dfsg-8_amd64.deb ...
#7 10.72 Unpacking p7zip (16.02+dfsg-8) ...
#7 10.75 Selecting previously unselected package p7zip-full.
#7 10.75 Preparing to unpack .../105-p7zip-full_16.02+dfsg-8_amd64.deb ...
#7 10.76 Unpacking p7zip-full (16.02+dfsg-8) ...
#7 10.85 Selecting previously unselected package unzip.
#7 10.85 Preparing to unpack .../106-unzip_6.0-26ubuntu3.2_amd64.deb ...
#7 10.86 Unpacking unzip (6.0-26ubuntu3.2) ...
#7 10.87 Selecting previously unselected package libglvnd-core-dev:amd64.
#7 10.87 Preparing to unpack .../107-libglvnd-core-dev_1.4.0-1_amd64.deb ...
#7 10.87 Unpacking libglvnd-core-dev:amd64 (1.4.0-1) ...
#7 10.88 Selecting previously unselected package libglvnd-dev:amd64.
#7 10.88 Preparing to unpack .../108-libglvnd-dev_1.4.0-1_amd64.deb ...
#7 10.88 Unpacking libglvnd-dev:amd64 (1.4.0-1) ...
#7 10.89 Selecting previously unselected package libgl1-mesa-dev:amd64.
#7 10.89 Preparing to unpack .../109-libgl1-mesa-dev_23.2.1-1ubuntu3.1~22.04.4_amd64.deb ...
#7 10.89 Unpacking libgl1-mesa-dev:amd64 (23.2.1-1ubuntu3.1~22.04.4) ...
#7 10.92 Setting up libexpat1:amd64 (2.4.7-1ubuntu0.9) ...
#7 10.92 Setting up libwayland-server0:amd64 (1.20.0-1ubuntu0.1) ...
#7 10.93 Setting up libpciaccess0:amd64 (0.16-3) ...
#7 10.93 Setting up libxau6:amd64 (1:1.0.9-1build5) ...
#7 10.93 Setting up libapparmor1:amd64 (3.0.4-2ubuntu2.5) ...
#7 10.94 Setting up libpsl5:amd64 (0.21.0-1.2build2) ...
#7 10.94 Setting up libogg0:amd64 (1.3.5-0ubuntu3) ...
#7 10.94 Setting up libglvnd-core-dev:amd64 (1.4.0-1) ...
#7 10.94 Setting up libmagic-mgc (1:5.41-3ubuntu0.1) ...
#7 10.94 Setting up libglvnd0:amd64 (1.4.0-1) ...
#7 10.95 Setting up unzip (6.0-26ubuntu3.2) ...
#7 10.95 Setting up libbrotli1:amd64 (1.0.9-2build6) ...
#7 10.95 Setting up libsensors-config (1:3.6.0-7ubuntu1) ...
#7 10.95 Setting up libnghttp2-14:amd64 (1.43.0-1ubuntu0.4) ...
#7 10.96 Setting up libmagic1:amd64 (1:5.41-3ubuntu0.1) ...
#7 10.96 Setting up xkb-data (2.33-1) ...
#7 10.96 Setting up file (1:5.41-3ubuntu0.1) ...
#7 10.96 Setting up perl-modules-5.34 (5.34.0-3ubuntu1.9) ...
#7 10.97 Setting up libpthread-stubs0-dev:amd64 (0.4-1build2) ...
#7 10.97 Setting up libopengl0:amd64 (1.4.0-1) ...
#7 10.97 Setting up libflac8:amd64 (1.3.3-2ubuntu0.2) ...
#7 10.97 Setting up libsasl2-modules-db:amd64 (2.1.27+dfsg2-3ubuntu1.2) ...
#7 10.97 Setting up xtrans-dev (1.4.0-1) ...
#7 10.98 Setting up libgles2:amd64 (1.4.0-1) ...
#7 10.98 Setting up libx11-data (2:1.7.5-1ubuntu0.3) ...
#7 10.98 Setting up librtmp1:amd64 (2.4+20151223.gitfa8646d.1-2build4) ...
#7 10.98 Setting up libgles1:amd64 (1.4.0-1) ...
#7 10.98 Setting up libdbus-1-3:amd64 (1.12.20-2ubuntu4.1) ...
#7 10.99 Setting up xz-utils (5.2.5-2ubuntu1.1) ...
#7 10.99 update-alternatives: using /usr/bin/xz to provide /usr/bin/lzma (lzma) in auto mode
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/lzma.1.gz because associated file /usr/share/man/man1/xz.1.gz (of link group lzma) doesn't exist
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/unlzma.1.gz because associated file /usr/share/man/man1/unxz.1.gz (of link group lzma) doesn't exist
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/lzcat.1.gz because associated file /usr/share/man/man1/xzcat.1.gz (of link group lzma) doesn't exist
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/lzmore.1.gz because associated file /usr/share/man/man1/xzmore.1.gz (of link group lzma) doesn't exist
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/lzless.1.gz because associated file /usr/share/man/man1/xzless.1.gz (of link group lzma) doesn't exist
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/lzdiff.1.gz because associated file /usr/share/man/man1/xzdiff.1.gz (of link group lzma) doesn't exist
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/lzcmp.1.gz because associated file /usr/share/man/man1/xzcmp.1.gz (of link group lzma) doesn't exist
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/lzgrep.1.gz because associated file /usr/share/man/man1/xzgrep.1.gz (of link group lzma) doesn't exist
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/lzegrep.1.gz because associated file /usr/share/man/man1/xzegrep.1.gz (of link group lzma) doesn't exist
#7 10.99 update-alternatives: warning: skip creation of /usr/share/man/man1/lzfgrep.1.gz because associated file /usr/share/man/man1/xzfgrep.1.gz (of link group lzma) doesn't exist
#7 10.99 Setting up libopus0:amd64 (1.3.1-0.1build2) ...
#7 10.99 Setting up libvorbis0a:amd64 (1.3.7-1build2) ...
#7 11.00 Setting up libsensors5:amd64 (1:3.6.0-7ubuntu1) ...
#7 11.00 Setting up libglapi-mesa:amd64 (23.2.1-1ubuntu3.1~22.04.4) ...
#7 11.00 Setting up libsasl2-2:amd64 (2.1.27+dfsg2-3ubuntu1.2) ...
#7 11.00 Setting up libssh-4:amd64 (0.9.6-2ubuntu0.22.04.8) ...
#7 11.00 Setting up libmd0:amd64 (1.0.4-1build1) ...
#7 11.00 Setting up libasyncns0:amd64 (0.8-6build2) ...
#7 11.01 Setting up libxshmfence1:amd64 (1.3-1build4) ...
#7 11.01 Setting up git-man (1:2.34.1-1ubuntu1.17) ...
#7 11.01 Setting up xorg-sgml-doctools (1:1.11-1.1) ...
#7 11.01 Setting up libopengl-dev:amd64 (1.4.0-1) ...
#7 11.01 Setting up openssl (3.0.2-0ubuntu1.30) ...
#7 11.02 Setting up libbsd0:amd64 (0.11.5-1) ...
#7 11.02 Setting up libdrm-common (2.4.113-2~ubuntu0.22.04.1) ...
#7 11.02 Setting up libelf1:amd64 (0.186-1ubuntu0.1) ...
#7 11.02 Setting up libonig5:amd64 (6.9.7.1-2build1) ...
#7 11.03 Setting up p7zip (16.02+dfsg-8) ...
#7 11.03 Setting up libvorbisenc2:amd64 (1.3.7-1build2) ...
#7 11.03 Setting up libgdbm6:amd64 (1.23-1) ...
#7 11.03 Setting up libicu70:amd64 (70.1-2) ...
#7 11.03 Setting up libxkbcommon0:amd64 (1.4.0-1) ...
#7 11.04 Setting up libwayland-client0:amd64 (1.20.0-1ubuntu0.1) ...
#7 11.04 Setting up x11proto-dev (2021.5-1) ...
#7 11.04 Setting up libxdmcp6:amd64 (1:1.1.3-0ubuntu5) ...
#7 11.04 Setting up libxcb1:amd64 (1.14-3ubuntu3) ...
#7 11.04 Setting up libxcb-xfixes0:amd64 (1.14-3ubuntu3) ...
#7 11.05 Setting up libxau-dev:amd64 (1:1.0.9-1build5) ...
#7 11.05 Setting up libjq1:amd64 (1.6-2.1ubuntu3.2) ...
#7 11.05 Setting up libxcb-glx0:amd64 (1.14-3ubuntu3) ...
#7 11.05 Setting up libedit2:amd64 (3.1-20210910-1build1) ...
#7 11.05 Setting up p7zip-full (16.02+dfsg-8) ...
#7 11.06 Setting up libxcb-shm0:amd64 (1.14-3ubuntu3) ...
#7 11.06 Setting up libldap-2.5-0:amd64 (2.5.20+dfsg-0ubuntu0.22.04.1) ...
#7 11.06 Setting up libxcb-xkb1:amd64 (1.14-3ubuntu3) ...
#7 11.06 Setting up libxcb-present0:amd64 (1.14-3ubuntu3) ...
#7 11.07 Setting up ca-certificates (20260601~22.04.1) ...
#7 11.32 Updating certificates in /etc/ssl/certs...
#7 11.63 121 added, 0 removed; done.
#7 11.64 Setting up libxdmcp-dev:amd64 (1:1.1.3-0ubuntu5) ...
#7 11.64 Setting up libxcb-sync1:amd64 (1.14-3ubuntu3) ...
#7 11.64 Setting up libxkbcommon-x11-0:amd64 (1.4.0-1) ...
#7 11.65 Setting up libgdbm-compat4:amd64 (1.23-1) ...
#7 11.65 Setting up libxcb-dri2-0:amd64 (1.14-3ubuntu3) ...
#7 11.65 Setting up libdrm2:amd64 (2.4.113-2~ubuntu0.22.04.1) ...
#7 11.65 Setting up libxcb-randr0:amd64 (1.14-3ubuntu3) ...
#7 11.65 Setting up jq (1.6-2.1ubuntu3.2) ...
#7 11.66 Setting up libcurl4:amd64 (7.81.0-1ubuntu1.29) ...
#7 11.66 Setting up libx11-6:amd64 (2:1.7.5-1ubuntu0.3) ...
#7 11.66 Setting up curl (7.81.0-1ubuntu1.29) ...
#7 11.66 Setting up libsndfile1:amd64 (1.0.31-2ubuntu0.2) ...
#7 11.66 Setting up libxml2:amd64 (2.9.13+dfsg-1ubuntu0.14) ...
#7 11.66 Setting up libdrm-amdgpu1:amd64 (2.4.113-2~ubuntu0.22.04.1) ...
#7 11.67 Setting up libxcb-dri3-0:amd64 (1.14-3ubuntu3) ...
#7 11.67 Setting up libx11-xcb1:amd64 (2:1.7.5-1ubuntu0.3) ...
#7 11.71 Setting up libperl5.34:amd64 (5.34.0-3ubuntu1.9) ...
#7 11.71 Setting up libdrm-nouveau2:amd64 (2.4.113-2~ubuntu0.22.04.1) ...
#7 11.71 Setting up libxcb1-dev:amd64 (1.14-3ubuntu3) ...
#7 11.71 Setting up libgbm1:amd64 (23.2.1-1ubuntu3.1~22.04.4) ...
#7 11.71 Setting up libpulse0:amd64 (1:15.99.1+dfsg1-1ubuntu2.2) ...
#7 11.72 Setting up libdrm-radeon1:amd64 (2.4.113-2~ubuntu0.22.04.1) ...
#7 11.72 Setting up libdrm-intel1:amd64 (2.4.113-2~ubuntu0.22.04.1) ...
#7 11.72 Setting up libx11-dev:amd64 (2:1.7.5-1ubuntu0.3) ...
#7 11.73 Setting up libxext6:amd64 (2:1.3.4-1build1) ...
#7 11.73 Setting up libcurl3-gnutls:amd64 (7.81.0-1ubuntu1.29) ...
#7 11.73 Setting up libxxf86vm1:amd64 (1:1.1.4-1build3) ...
#7 11.73 Setting up perl (5.34.0-3ubuntu1.9) ...
#7 11.74 Setting up libegl-mesa0:amd64 (23.2.1-1ubuntu3.1~22.04.4) ...
#7 11.74 Setting up libxfixes3:amd64 (1:6.0.0-1) ...
#7 11.74 Setting up libllvm15:amd64 (1:15.0.7-0ubuntu0.22.04.3) ...
#7 11.74 Setting up libegl1:amd64 (1.4.0-1) ...
#7 11.75 Setting up libgl1-mesa-dri:amd64 (23.2.1-1ubuntu3.1~22.04.4) ...
#7 11.75 Setting up liberror-perl (0.17029-1) ...
#7 11.75 Setting up git (1:2.34.1-1ubuntu1.17) ...
#7 11.76 Setting up libglx-mesa0:amd64 (23.2.1-1ubuntu3.1~22.04.4) ...
#7 11.76 Setting up libglx0:amd64 (1.4.0-1) ...
#7 11.76 Setting up libgl1:amd64 (1.4.0-1) ...
#7 11.77 Setting up libglx-dev:amd64 (1.4.0-1) ...
#7 11.77 Setting up libgl-dev:amd64 (1.4.0-1) ...
#7 11.77 Setting up libegl-dev:amd64 (1.4.0-1) ...
#7 11.77 Setting up libgles-dev:amd64 (1.4.0-1) ...
#7 11.77 Setting up libglvnd-dev:amd64 (1.4.0-1) ...
#7 11.77 Setting up libgl1-mesa-dev:amd64 (23.2.1-1ubuntu3.1~22.04.4) ...
#7 11.78 Processing triggers for libc-bin (2.35-0ubuntu3.15) ...
#7 11.79 Processing triggers for ca-certificates (20260601~22.04.1) ...
#7 11.79 Updating certificates in /etc/ssl/certs...
#7 12.03 0 added, 0 removed; done.
#7 12.03 Running hooks in /etc/ca-certificates/update.d...
#7 12.03 done.
#7 DONE 14.0s

#8 [ 3/17] RUN curl -fsSL "https://api.adoptium.net/v3/binary/latest/17/ga/linux/x64/jdk/hotspot/normal/eclipse"     | tar xz -C /opt && mv /opt/jdk-17* /opt/jdk-17
#8 DONE 5.2s

#9 [ 4/17] RUN curl -fsSL https://nodejs.org/dist/v18.20.1/node-v18.20.1-linux-x64.tar.xz     | tar xJ -C /opt && mv /opt/node-v18.20.1-linux-x64 /opt/node
#9 DONE 2.9s

#10 [ 5/17] RUN set -eux;     mkdir -p /opt/android-sdk/cmdline-tools;     curl -fsSL --retry 3 --retry-all-errors       "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"       -o /tmp/cmdline-tools.zip;     unzip -q /tmp/cmdline-tools.zip -d /opt/android-sdk/cmdline-tools;     mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest;     rm -f /tmp/cmdline-tools.zip;     yes | sdkmanager --sdk_root=/opt/android-sdk --licenses >/dev/null 2>&1 || true;     for pkg in "platform-tools"                "platforms;android-34" "platforms;android-35" "platforms;android-36"                "build-tools;34.0.0" "build-tools;35.0.0" "build-tools;36.0.0"; do         sdkmanager --sdk_root=/opt/android-sdk "$pkg" >/dev/null 2>&1           || echo "WARN: sdkmanager could not install $pkg (may not exist for this cmdline-tools rev) - continuing";     done;     yes | sdkmanager --sdk_root=/opt/android-sdk --licenses >/dev/null 2>&1 || true
#10 0.103 + mkdir -p /opt/android-sdk/cmdline-tools
#10 0.104 + curl -fsSL --retry 3 --retry-all-errors https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o /tmp/cmdline-tools.zip
#10 0.848 + unzip -q /tmp/cmdline-tools.zip -d /opt/android-sdk/cmdline-tools
#10 1.580 + mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest
#10 1.581 + rm -f /tmp/cmdline-tools.zip
#10 1.595 + yes
#10 1.595 + sdkmanager --sdk_root=/opt/android-sdk --licenses
#10 3.217 + sdkmanager --sdk_root=/opt/android-sdk platform-tools
#10 5.182 + sdkmanager --sdk_root=/opt/android-sdk platforms;android-34
#10 9.252 + sdkmanager --sdk_root=/opt/android-sdk platforms;android-35
#10 13.20 + sdkmanager --sdk_root=/opt/android-sdk platforms;android-36
#10 17.46 + sdkmanager --sdk_root=/opt/android-sdk build-tools;34.0.0
#10 20.54 + sdkmanager --sdk_root=/opt/android-sdk build-tools;35.0.0
#10 23.55 + sdkmanager --sdk_root=/opt/android-sdk build-tools;36.0.0
#10 26.60 + yes
#10 26.60 + sdkmanager --sdk_root=/opt/android-sdk --licenses
#10 DONE 28.6s

#11 [ 6/17] RUN set -eux;     mkdir -p /tmp/clt;     cd /tmp/clt;     curl -fsSL --retry 3 --retry-all-errors -o part_aa "https://github.com/zhongdaiqi/command-line-tools-for-hmos/releases/download/clt-26.0.0.851/commandline-tools-linux-x64-26.0.0.851.part_aa";     curl -fsSL --retry 3 --retry-all-errors -o part_ab "https://github.com/zhongdaiqi/command-line-tools-for-hmos/releases/download/clt-26.0.0.851/commandline-tools-linux-x64-26.0.0.851.part_ab";     cat part_aa part_ab > clt.zip;     rm -f part_aa part_ab;     unzip -q clt.zip -d /tmp/clt/x || {         echo "unzip failed - retrying with 7z";         rm -rf /tmp/clt/x;         7z x -y -o/tmp/clt/x clt.zip >/dev/null;     };     rm -f clt.zip;     test -d /tmp/clt/x/command-line-tools;     rm -rf /opt/ohos-sdk;     mv /tmp/clt/x/command-line-tools /opt/ohos-sdk;     rm -rf /tmp/clt
#11 0.098 + mkdir -p /tmp/clt
#11 0.100 + cd /tmp/clt
#11 0.100 + curl -fsSL --retry 3 --retry-all-errors -o part_aa https://github.com/zhongdaiqi/command-line-tools-for-hmos/releases/download/clt-26.0.0.851/commandline-tools-linux-x64-26.0.0.851.part_aa
#11 4.114 + curl -fsSL --retry 3 --retry-all-errors -o part_ab https://github.com/zhongdaiqi/command-line-tools-for-hmos/releases/download/clt-26.0.0.851/commandline-tools-linux-x64-26.0.0.851.part_ab
#11 8.250 + cat part_aa part_ab
#11 15.07 + rm -f part_aa part_ab
#11 15.26 + unzip -q clt.zip -d /tmp/clt/x
#11 64.98 + rm -f clt.zip
#11 65.06 + test -d /tmp/clt/x/command-line-tools
#11 65.06 + rm -rf /opt/ohos-sdk
#11 65.06 + mv /tmp/clt/x/command-line-tools /opt/ohos-sdk
#11 65.07 + rm -rf /tmp/clt
#11 DONE 69.8s

#12 [ 7/17] RUN echo "=== ls -la /opt/ohos-sdk ===";        ls -la /opt/ohos-sdk || true;     echo "=== dirs up to depth 2 ===";          find /opt/ohos-sdk -maxdepth 2 -type d 2>/dev/null | sort || true;     echo "=== ls -la /opt/ohos-sdk/bin ===";    ls -la /opt/ohos-sdk/bin || true;     echo "=== ls -la /opt/ohos-sdk/sdk ===";    ls -la /opt/ohos-sdk/sdk || true;     echo "=== ls -la /opt/ohos-sdk/sdk/default ==="; ls -la /opt/ohos-sdk/sdk/default || true;     echo "=== sdk-pkg.json (read by flutter_tools) ==="; cat /opt/ohos-sdk/sdk/default/sdk-pkg.json || true;     echo "=== cat version.txt ===";             cat /opt/ohos-sdk/version.txt || true;     echo "=== hvigor version ===";              cat /opt/ohos-sdk/hvigor/hvigor/package.json | head -5 || true;     echo "=== command -v hvigorw ===";          command -v hvigorw || true;     echo "=== command -v ohpm ===";             command -v ohpm || true;     echo "=== df -h / ===";                     df -h / || true;     true
#12 0.098 === ls -la /opt/ohos-sdk ===
#12 0.100 total 268
#12 0.100 drwx------ 11 root root   4096 Sep 21 23:20 .
#12 0.100 drwxr-xr-x  1 root root   4096 Oct 10 19:06 ..
#12 0.100 -rw-------  1 root root 106536 Sep 21 23:10 LICENSE.txt
#12 0.100 -rw-------  1 root root 110759 Sep 21 23:10 NOTICE.txt
#12 0.100 drwx------  5 root root   4096 Sep 21 23:13 arktsdoc
#12 0.100 drwx------  2 root root   4096 Sep 21 23:19 bin
#12 0.100 drwx------  5 root root   4096 Sep 21 23:15 codelinter
#12 0.100 drwx------  8 root root   4096 Sep 21 23:10 emulator
#12 0.100 drwx------  4 root root   4096 Sep 21 23:15 hstack
#12 0.100 drwx------  5 root root   4096 Sep 21 23:19 hvigor
#12 0.100 drwx------  6 root root   4096 Sep 21 23:11 ohpm
#12 0.100 drwx------  3 root root   4096 Sep 21 23:14 sdk
#12 0.100 drwx------  3 root root   4096 Sep 21 23:10 tool
#12 0.100 -rw-------  1 root root    378 Sep 21 23:20 version.txt
#12 0.100 === dirs up to depth 2 ===
#12 0.101 /opt/ohos-sdk
#12 0.101 /opt/ohos-sdk/arktsdoc
#12 0.101 /opt/ohos-sdk/arktsdoc/bin
#12 0.101 /opt/ohos-sdk/arktsdoc/build
#12 0.101 /opt/ohos-sdk/arktsdoc/node_modules
#12 0.101 /opt/ohos-sdk/bin
#12 0.101 /opt/ohos-sdk/codelinter
#12 0.101 /opt/ohos-sdk/codelinter/bin
#12 0.101 /opt/ohos-sdk/codelinter/linter
#12 0.101 /opt/ohos-sdk/codelinter/node_modules
#12 0.101 /opt/ohos-sdk/emulator
#12 0.101 /opt/ohos-sdk/emulator/agreement
#12 0.101 /opt/ohos-sdk/emulator/lib
#12 0.101 /opt/ohos-sdk/emulator/pc-bios
#12 0.101 /opt/ohos-sdk/emulator/plugins
#12 0.101 /opt/ohos-sdk/emulator/properties
#12 0.101 /opt/ohos-sdk/emulator/translations
#12 0.101 /opt/ohos-sdk/hstack
#12 0.101 /opt/ohos-sdk/hstack/bin
#12 0.101 /opt/ohos-sdk/hstack/lib
#12 0.101 /opt/ohos-sdk/hvigor
#12 0.101 /opt/ohos-sdk/hvigor/bin
#12 0.101 /opt/ohos-sdk/hvigor/hvigor
#12 0.101 /opt/ohos-sdk/hvigor/hvigor-ohos-plugin
#12 0.101 /opt/ohos-sdk/ohpm
#12 0.101 /opt/ohos-sdk/ohpm/bin
#12 0.101 /opt/ohos-sdk/ohpm/lib
#12 0.101 /opt/ohos-sdk/ohpm/node_modules
#12 0.101 /opt/ohos-sdk/ohpm/resources
#12 0.101 /opt/ohos-sdk/sdk
#12 0.101 /opt/ohos-sdk/sdk/default
#12 0.101 /opt/ohos-sdk/tool
#12 0.101 /opt/ohos-sdk/tool/node
#12 0.101 === ls -la /opt/ohos-sdk/bin ===
#12 0.102 total 32
#12 0.102 drwx------  2 root root 4096 Sep 21 23:19 .
#12 0.102 drwx------ 11 root root 4096 Sep 21 23:20 ..
#12 0.102 -r-xr-----  1 root root  272 Sep 21 23:10 Emulator
#12 0.102 -r-xr-----  1 root root  540 Sep 21 23:13 arktsdoc
#12 0.102 -r-xr-----  1 root root  758 Sep 21 23:15 codelinter
#12 0.102 -r-xr-----  1 root root  528 Sep 21 23:15 hstack
#12 0.102 -r-xr-----  1 root root  737 Sep 21 23:19 hvigorw
#12 0.102 -r-xr-----  1 root root  516 Sep 21 23:11 ohpm
#12 0.102 === ls -la /opt/ohos-sdk/sdk ===
#12 0.102 total 12
#12 0.102 drwx------  3 root root 4096 Sep 21 23:14 .
#12 0.102 drwx------ 11 root root 4096 Sep 21 23:20 ..
#12 0.102 drwx------  4 root root 4096 Sep 21 23:17 default
#12 0.102 === ls -la /opt/ohos-sdk/sdk/default ===
#12 0.103 total 20
#12 0.103 drwx------ 4 root root 4096 Sep 21 23:17 .
#12 0.103 drwx------ 3 root root 4096 Sep 21 23:14 ..
#12 0.103 drwxr-xr-x 7 root root 4096 Sep 16 00:30 hms
#12 0.103 drwxr-xr-x 7 root root 4096 Sep 16 00:33 openharmony
#12 0.103 -rw-r--r-- 1 root root  322 Sep 16 00:27 sdk-pkg.json
#12 0.103 === sdk-pkg.json (read by flutter_tools) ===
#12 0.104 {
#12 0.104     "meta": {
#12 0.104         "version": "1.0.0"
#12 0.104     },
#12 0.104     "data": {
#12 0.104         "apiVersion": "26",
#12 0.104         "displayName": "HarmonyOS 26.0.0",
#12 0.104         "path": "HarmonyOS-26.0.0",
#12 0.104         "platformVersion": "26.0.0",
#12 0.104         "releaseType": "Release",
#12 0.104         "version": "26.0.0.105",
#12 0.104         "stage": "Release"
#12 0.104     }
#12 0.104 }=== cat version.txt ===
#12 0.104 # ======================
#12 0.104 # Command Line Tools(linux-x64)
#12 0.104 # Version: 26.0.0.851
#12 0.104 # ======================
#12 0.104 
#12 0.104 hstack         : 6.1.0
#12 0.104 codelinter     : 6.0.240
#12 0.104 hvigor         : 6.26.8
#12 0.104 releaseType    : release
#12 0.104 ohpm           : 26.0.0.630
#12 0.104 HarmonyOS SDK  : HarmonyOS 26.0.0 Release (include Ohos_sdk_public 26.0.0.105 (API Version 26 Release))
#12 0.104 apiVersion     : 26
#12 0.104 platformVersion: 26.0.0
#12 0.104 === hvigor version ===
#12 0.105 {
#12 0.105   "name": "@ohos/hvigor",
#12 0.105   "version": "6.26.8",
#12 0.105   "description": "The ohos build system cli tools.",
#12 0.105   "main": "./index.js",
#12 0.105 === command -v hvigorw ===
#12 0.105 /opt/ohos-sdk/bin/hvigorw
#12 0.105 === command -v ohpm ===
#12 0.105 /opt/ohos-sdk/bin/ohpm
#12 0.105 === df -h / ===
#12 0.105 Filesystem      Size  Used Avail Use% Mounted on
#12 0.105 overlay         145G   48G   98G  33% /
#12 DONE 0.1s

#13 [ 8/17] RUN test -x /opt/ohos-sdk/bin/hvigorw && test -x /opt/ohos-sdk/bin/ohpm     && echo "ASSERT OK: bin/hvigorw and bin/ohpm are present and executable"
#13 0.102 ASSERT OK: bin/hvigorw and bin/ohpm are present and executable
#13 DONE 0.1s

#14 [ 9/17] RUN test ! -e /opt/ohos-sdk/command-line-tools     && echo "ASSERT OK: no nested command-line-tools/ level under /opt/ohos-sdk"
#14 0.102 ASSERT OK: no nested command-line-tools/ level under /opt/ohos-sdk
#14 DONE 0.1s

#15 [10/17] RUN test -f /opt/ohos-sdk/sdk/default/sdk-pkg.json     && echo "ASSERT OK: sdk/default/sdk-pkg.json (apiVersion) exists"
#15 0.102 ASSERT OK: sdk/default/sdk-pkg.json (apiVersion) exists
#15 DONE 0.1s

#16 [11/17] RUN test -f /opt/ohos-sdk/hvigor/hvigor/package.json     && test -f /opt/ohos-sdk/hvigor/bin/hvigorw.js     && echo "ASSERT OK: hvigor runtime is present"
#16 0.103 ASSERT OK: hvigor runtime is present
#16 DONE 0.1s

#17 [12/17] RUN echo "=== sdkmanager version ==="; sdkmanager --version || true;     echo "=== installed Android packages ===";     sdkmanager --sdk_root=/opt/android-sdk --list_installed 2>/dev/null | grep -E 'Android SDK|platforms|build-tools' || true;     test -x /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager       && echo "ASSERT OK: sdkmanager is present and executable";     test -d /opt/android-sdk/platforms/android-35       && echo "ASSERT OK: platforms;android-35 present (covers Flutter 3.41 default compileSdk)"
#17 0.088 === sdkmanager version ===
#17 0.592 12.0
#17 0.592 
#17 0.607 === installed Android packages ===
#17 1.147   build-tools;34.0.0   | 34.0.0  | Android SDK Build-Tools 34 | build-tools/34.0.0  
#17 1.147   build-tools;35.0.0   | 35.0.0  | Android SDK Build-Tools 35 | build-tools/35.0.0  
#17 1.147   build-tools;36.0.0   | 36.0.0  | Android SDK Build-Tools 36 | build-tools/36.0.0  
#17 1.147   platform-tools       | 37.0.1  | Android SDK Platform-Tools | platform-tools      
#17 1.147   platforms;android-34 | 3       | Android SDK Platform 34    | platforms/android-34
#17 1.147   platforms;android-35 | 2       | Android SDK Platform 35    | platforms/android-35
#17 1.147   platforms;android-36 | 2       | Android SDK Platform 36    | platforms/android-36
#17 1.148 ASSERT OK: sdkmanager is present and executable
#17 1.148 ASSERT OK: platforms;android-35 present (covers Flutter 3.41 default compileSdk)
#17 DONE 1.2s

#18 [13/17] RUN git clone --depth 1 -b 3.41.10-ohos-1.0.1     https://github.com/zhongdaiqi/flutter_flutter.git /opt/flutter
#18 0.092 Cloning into '/opt/flutter'...
#18 2.839 Note: switching to 'adaf911c35c9136a7d18fc424d714c9ec7724e60'.
#18 2.839 
#18 2.839 You are in 'detached HEAD' state. You can look around, make experimental
#18 2.839 changes and commit them, and you can discard any commits you make in this
#18 2.839 state without impacting any branches by switching back to a branch.
#18 2.839 
#18 2.839 If you want to create a new branch to retain commits you create, you may
#18 2.839 do so (now or later) by using -c with the switch command. Example:
#18 2.839 
#18 2.839   git switch -c <new-branch-name>
#18 2.839 
#18 2.839 Or undo this operation with:
#18 2.839 
#18 2.839   git switch -
#18 2.839 
#18 2.839 Turn off this advice by setting config variable advice.detachedHead to false
#18 2.839 
#18 DONE 5.1s

#19 [14/17] RUN hvigorw -v && ohpm -v
#19 0.327 6.26.8
#19 0.760 26.0.0.630
#19 DONE 0.8s

#20 [15/17] RUN echo "--- compatibility summary ---";     echo "SDK apiVersion      : $(jq -r '.data.apiVersion' /opt/ohos-sdk/sdk/default/sdk-pkg.json 2>/dev/null || echo '?')";     echo "SDK platformVersion : $(jq -r '.data.platformVersion' /opt/ohos-sdk/sdk/default/sdk-pkg.json 2>/dev/null || echo '?')";     echo "SDK displayName     : $(jq -r '.data.displayName' /opt/ohos-sdk/sdk/default/sdk-pkg.json 2>/dev/null || echo '?')";     echo "hvigor version      : $(jq -r '.version' /opt/ohos-sdk/hvigor/hvigor/package.json 2>/dev/null || echo '?')";     echo "flutter tag         : 3.41.10-ohos-1.0.1";     echo "template compatSdk  : $(grep -rh compatibleSdkVersion /opt/flutter/packages/flutter_tools/templates/app/ohos.tmpl/build-profile.json5.tmpl 2>/dev/null | tr -d ' ' || echo '?')";     echo "template modelVer   : $(grep -rh modelVersion /opt/flutter/packages/flutter_tools/templates/app/ohos.tmpl/oh-package.json5.tmpl 2>/dev/null | tr -d ' ' || echo '?')"
#20 0.104 --- compatibility summary ---
#20 0.121 SDK apiVersion      : 26
#20 0.138 SDK platformVersion : 26.0.0
#20 0.155 SDK displayName     : HarmonyOS 26.0.0
#20 0.172 hvigor version      : 6.26.8
#20 0.172 flutter tag         : 3.41.10-ohos-1.0.1
#20 0.173 template compatSdk  : "compatibleSdkVersion":"5.1.0(18)",
#20 0.174 template modelVer   : "modelVersion":"5.1.0",
#20 DONE 0.2s

#21 [16/17] COPY entrypoint.sh /entrypoint.sh
#21 DONE 0.0s

#22 [17/17] RUN chmod +x /entrypoint.sh
#22 DONE 0.1s

#23 exporting to image
#23 exporting layers
#23 exporting layers 47.5s done
#23 writing image sha256:aaf6e8760bd03c8c090ba698e3f0d63c6eef6b07f702f3df3390a4a4e26a042f done
#23 naming to docker.io/library/flutter-ohos-builder:test done
#23 DONE 47.5s
```

## probe.log (last 500 lines)
```
+ df -h /
Filesystem      Size  Used Avail Use% Mounted on
overlay         145G   48G   97G  33% /
+ echo '===== SDK metadata (.data) ====='
===== SDK metadata (.data) =====
+ cat /opt/ohos-sdk/sdk/default/sdk-pkg.json
{
    "meta": {
        "version": "1.0.0"
    },
    "data": {
        "apiVersion": "26",
        "displayName": "HarmonyOS 26.0.0",
        "path": "HarmonyOS-26.0.0",
        "platformVersion": "26.0.0",
        "releaseType": "Release",
        "version": "26.0.0.105",
        "stage": "Release"
    }
}+ echo '===== flutter --version ====='
+ flutter --version
===== flutter --version =====
Downloading Linux x64 Dart SDK from Flutter engine 3fb08d34b6f96a15fbb219b903c9d0ab37b6c2e0...
dart-sdk-url: https://flutter-ohos.obs.cn-south-1.myhuaweicloud.com/flutter_infra_release/flutter/3fb08d34b6f96a15fbb219b903c9d0ab37b6c2e0/dart-sdk-linux-x64.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0  0  193M    0  192k    0     0  99648      0  0:33:57  0:00:01  0:33:56 99649  0  193M    0 1504k    0     0   507k      0  0:06:31  0:00:02  0:06:29  507k  3  193M    3 6240k    0     0  1563k      0  0:02:06  0:00:03  0:02:03 1563k  6  193M    6 12.4M    0     0  2564k      0  0:01:17  0:00:04  0:01:13 2564k  9  193M    9 18.6M    0     0  3172k      0  0:01:02  0:00:06  0:00:56 3890k 12  193M   12 24.8M    0     0  3641k      0  0:00:54  0:00:06  0:00:48 5034k 16  193M   16 31.0M    0     0  3949k      0  0:00:50  0:00:08  0:00:42 5957k 19  193M   19 36.8M    0     0  4209k      0  0:00:47  0:00:08  0:00:39 6331k 22  193M   22 42.7M    0     0  4388k      0  0:00:45  0:00:09  0:00:36 6200k 25  193M   25 49.6M    0     0  4582k      0  0:00:43  0:00:11  0:00:32 6259k 28  193M   28 55.1M    0     0  4708k      0  0:00:42  0:00:11  0:00:31 6201k 31  193M   31 61.9M    0     0  4889k      0  0:00:40  0:00:12  0:00:28 6429k 34  193M   34 67.5M    0     0  4933k      0  0:00:40  0:00:14  0:00:26 6216k 38  193M   38 73.8M    0     0  5053k      0  0:00:39  0:00:14  0:00:25 6379k 41  193M   41 79.9M    0     0  5101k      0  0:00:38  0:00:16  0:00:22 6265k 44  193M   44 85.8M    0     0  5184k      0  0:00:38  0:00:16  0:00:22 6330k 47  193M   47 92.4M    0     0  5236k      0  0:00:37  0:00:18  0:00:19 6119k 50  193M   50 97.9M    0     0  5288k      0  0:00:37  0:00:18  0:00:19 6292k 53  193M   53  104M    0     0  5324k      0  0:00:37  0:00:20  0:00:17 6127k 57  193M   57  110M    0     0  5395k      0  0:00:36  0:00:20  0:00:16 6354k 59  193M   59  115M    0     0  5330k      0  0:00:37  0:00:22  0:00:15 5814k 62  193M   62  120M    0     0  5366k      0  0:00:36  0:00:23  0:00:13 5842k 65  193M   65  127M    0     0  5439k      0  0:00:36  0:00:23  0:00:13 6011k 68  193M   68  132M    0     0  5440k      0  0:00:36  0:00:25  0:00:11 5906k 71  193M   71  139M    0     0  5488k      0  0:00:36  0:00:25  0:00:11 5878k 75  193M   75  145M    0     0  5515k      0  0:00:35  0:00:26  0:00:09 6353k 78  193M   78  151M    0     0  5543k      0  0:00:35  0:00:27  0:00:08 6357k 81  193M   81  157M    0     0  5569k      0  0:00:35  0:00:29  0:00:06 6188k 84  193M   84  163M    0     0  5594k      0  0:00:35  0:00:30  0:00:05 6363k 87  193M   87  170M    0     0  5614k      0  0:00:35  0:00:31  0:00:04 6262k 91  193M   91  176M    0     0  5636k      0  0:00:35  0:00:32  0:00:03 6282k 93  193M   93  181M    0     0  5634k      0  0:00:35  0:00:33  0:00:02 6141k 96  193M   96  187M    0     0  5662k      0  0:00:35  0:00:33  0:00:02 6206k100  193M  100  193M    0     0  5684k      0  0:00:34  0:00:34 --:--:-- 6242k
Building flutter tool...
Resolving dependencies...
Downloading packages...
Got dependencies.
Flutter 3.41.10-ohos-1.0.1 • channel [user-branch] • unknown source
Framework • revision adaf911c35 (8 weeks ago) • 2026-08-17 17:01:32 +0700
Engine • hash 9161402dc0e134b3fb5adee5046b6e84b1a5e1c1 (revision 42d3d75a56) (5 months ago) • 2026-04-28 17:31:55.000Z
Tools • Dart 3.11.5 • DevTools 2.54.1
+ echo '===== flutter doctor -v ====='
+ flutter doctor -v
===== flutter doctor -v =====
Downloading Material fonts...                                      267ms
Downloading Gradle Wrapper...                                       23ms
Downloading package sky_engine...                                2,973ms
Downloading package flutter_gpu...                                  60ms
Downloading flutter_patched_sdk tools...                           983ms
Downloading flutter_patched_sdk_product tools...                    3.5s
Downloading linux-x64 tools...                                      5.4s
Downloading linux-x64/font-subset tools...                         166ms
[!] Flutter (Channel [user-branch], 3.41.10-ohos-1.0.1, on Ubuntu 22.04.5 LTS 6.17.0-1022-azure, locale en_US) [35ms]
    ! Flutter version 3.41.10-ohos-1.0.1 on channel [user-branch] at /opt/flutter
      Currently on an unknown channel. Run `flutter channel` to switch to an official channel.
      If that doesn't fix the issue, reinstall Flutter by following instructions at https://flutter.dev/setup.
    ! Upstream repository unknown source is not a standard remote.
      Set environment variable "FLUTTER_GIT_URL" to unknown source to dismiss this error.
    • Framework revision adaf911c35 (8 weeks ago), 2026-08-17 17:01:32 +0700
    • Engine revision 42d3d75a56
    • Dart version 3.11.5
    • DevTools version 2.54.1
    • Feature flags: enable-ohos, enable-web, enable-linux-desktop, enable-macos-desktop, enable-windows-desktop, enable-android, enable-ios, cli-animations, enable-native-assets, omit-legacy-version-file, enable-lldb-debugging, enable-uiscene-migration
    • If those were intentional, you can disregard the above warnings; however it is recommended to use "git" directly to perform update checks and upgrades.

[✓] HarmonyOS toolchain - develop for HarmonyOS devices
    • OpenHarmony Sdk at /opt/ohos-sdk/sdk, available api versions has [26:default]
    • Ohpm version 26.0.0.630
    • Node version v24.14.1
    • Hvigorw binary at /opt/ohos-sdk/bin/hvigorw

[✓] Android toolchain - develop for Android devices (Android SDK version 36.0.0) [1,582ms]
    • Android SDK at /opt/android-sdk
    • Emulator version unknown
    • Platform android-36, build-tools 36.0.0
    • ANDROID_HOME = /opt/android-sdk
    • ANDROID_SDK_ROOT = /opt/android-sdk
    • Java binary at: /opt/jdk-17/bin/java
      This JDK is specified by the JAVA_HOME environment variable.
      To manually set the JDK path, use: `flutter config --jdk-dir="path/to/jdk"`.
    • Java version OpenJDK Runtime Environment Temurin-17.0.20.1+1 (build 17.0.20.1+1)
    • All Android licenses accepted.

[✗] Chrome - develop for the web (Cannot find Chrome executable at google-chrome) [118ms]
    ! Cannot find Chrome. Try setting CHROME_EXECUTABLE to a Chrome executable.

[✗] Linux toolchain - develop for Linux desktop [123ms]
    ✗ clang++ is required for Linux development.
      It is likely available from your distribution (e.g.: apt install clang), or can be downloaded from https://releases.llvm.org/
    ✗ CMake is required for Linux development.
      It is likely available from your distribution (e.g.: apt install cmake), or can be downloaded from https://cmake.org/download/
    ✗ ninja is required for Linux development.
      It is likely available from your distribution (e.g.: apt install ninja-build), or can be downloaded from https://github.com/ninja-build/ninja/releases
    ✗ pkg-config is required for Linux development.
      It is likely available from your distribution (e.g.: apt install pkg-config), or can be downloaded from https://www.freedesktop.org/wiki/Software/pkg-config/

[☠] Connected device (the doctor check crashed)
    ✗ Due to an error, the doctor check did not complete. If the error message below is not helpful, please let us know about this issue at https://github.com/flutter/flutter/issues.
    ✗ Error: Unable to run "hdc", check your Ohos SDK installation and OHOS_SDK_HOME environment variable: /opt/ohos-sdk/sdk/default/openharmony/toolchains/hdc
    • #0      throwToolExit (package:flutter_tools/src/base/common.dart:34:3)
      #1      OhosDevices.pollingGetDevices (package:flutter_tools/src/ohos/ohos_device_discovery.dart:58:7)
      <asynchronous suspension>
      #2      PollingDeviceDiscovery._populateDevices (package:flutter_tools/src/device.dart:560:36)
      <asynchronous suspension>
      #3      Future.wait.<anonymous closure> (dart:async/future.dart:546:21)
      <asynchronous suspension>
      #4      DeviceManager.refreshAllDevices (package:flutter_tools/src/device.dart:203:40)
      <asynchronous suspension>
      #5      DeviceValidator.validateImpl (package:flutter_tools/src/doctor.dart:746:34)
      <asynchronous suspension>
      #6      DoctorValidator.validate (package:flutter_tools/src/doctor_validator.dart:58:37)
      <asynchronous suspension>
      #7      Future.any.onValue (dart:async/future.dart:637:5)
      <asynchronous suspension>


[✓] Network resources [390ms]
    • All expected network resources are available.

! Doctor found issues in 4 categories.
+ echo '===== flutter create ====='
+ cd /tmp
+ flutter create --platforms=ohos --project-name probe /tmp/probe
===== flutter create =====
Creating project probe...
Resolving dependencies in `probe`...
Downloading packages...
Got dependencies in `probe`.
Wrote 45 files.

All done!
You can find general documentation for Flutter at: https://docs.flutter.dev/
Detailed API documentation is available at: https://api.flutter.dev/
If you prefer video documentation, consider: https://www.youtube.com/c/flutterdev

In order to run your application, type:

  $ cd probe
  $ flutter run

Your application code is in probe/lib/main.dart.

+ echo '===== generated ohos/build-profile.json5 ====='
+ cat /tmp/probe/ohos/build-profile.json5
===== generated ohos/build-profile.json5 =====

{
  "app": {
    "signingConfigs": [],
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
        "compatibleSdkVersion": "5.1.0(18)",
        "runtimeOS": "HarmonyOS",
      }
    ],
    "buildModeSet": [
      {
        "name": "debug"
      },
      {
        "name": "profile"
      },
      {
        "name": "release"
      }
    ]
  },
  "modules": [
    {
      "name": "entry",
      "srcPath": "./entry",
      "targets": [
        {
          "name": "default",
          "applyToProducts": [
            "default"
          ]
        }
      ]
    }
  ]
}+ echo '===== generated ohos/entry/build-profile.json5 ====='
+ cat /tmp/probe/ohos/entry/build-profile.json5
===== generated ohos/entry/build-profile.json5 =====

{
  "apiType": 'stageMode',
  "buildOption": {
  },
  "targets": [
    {
      "name": "default",
      "runtimeOS": "HarmonyOS"
    },
    {
      "name": "ohosTest",
    }
  ]
}+ echo '===== generated ohos/oh-package.json5 ====='
+ cat /tmp/probe/ohos/oh-package.json5
===== generated ohos/oh-package.json5 =====
{
  "modelVersion": "5.1.0",
  "name": "probe",
  "version": "1.0.0",
  "description": "Please describe the basic information.",
  "main": "",
  "author": "",
  "license": "",
  "dependencies": {},
  "devDependencies": {
    "@ohos/hypium": "1.0.6"
  }
}
===== generated ohos/hvigor/hvigor-config.json5 =====
+ echo '===== generated ohos/hvigor/hvigor-config.json5 ====='
+ cat /tmp/probe/ohos/hvigor/hvigor-config.json5

{
  "modelVersion": "5.1.0",
  "dependencies": {
  }
}+ echo '===== ls generated ohos ====='
+ ls -la /tmp/probe/ohos
===== ls generated ohos =====
total 56
drwxr-xr-x 6 root root 4096 Oct 10 19:08 .
drwxr-xr-x 7 root root 4096 Oct 10 19:08 ..
-rw-r--r-- 1 root root  327 Oct 10 19:08 .gitignore
drwxr-xr-x 3 root root 4096 Oct 10 19:08 AppScope
-rw-r--r-- 1 root root  606 Oct 10 19:08 build-profile.json5
drwxr-xr-x 3 root root 4096 Oct 10 19:08 entry
drwxr-xr-x 2 root root 4096 Oct 10 19:08 hvigor
-rw-r--r-- 1 root root  141 Oct 10 19:08 hvigorconfig.ts
-rw-r--r-- 1 root root  362 Oct 10 19:08 hvigorfile.ts
-rw-r--r-- 1 root root   73 Oct 10 19:08 local.properties
drwxr-xr-x 2 root root 4096 Oct 10 19:08 node_modules
-rw-r--r-- 1 root root  255 Oct 10 19:08 oh-package.json5
-rw-r--r-- 1 root root  582 Oct 10 19:08 package-lock.json
-rw-r--r-- 1 root root  106 Oct 10 19:08 package.json
+ echo '===== hvigorw -v (in project) ====='
===== hvigorw -v (in project) =====
+ cd /tmp/probe/ohos
+ hvigorw -v --no-daemon
6.26.8
+ echo '===== hvigorw --sync --no-daemon ====='
+ cd /tmp/probe/ohos
===== hvigorw --sync --no-daemon =====
+ hvigorw --sync --no-daemon
Installing pnpm@10.28.2...

added 1 package, and audited 2 packages in 1s

1 package is looking for funding
  run `npm fund` for details

1 high severity vulnerability

To address all issues, run:
  npm audit fix --force

Run `npm audit` for details.
Pnpm install success.
> hvigor [32mstart to execute ohpm install[39m
ohpm INFO: MetaDataFetcher fetching meta info of package '@ohos/hypium' from https://ohpm.openharmony.cn/ohpm/
[31mohpm ERROR: Run install command failed 
Error: 00625003 File Not Exist
Error Message: File: /opt/flutter/bin/cache/artifacts/engine/ohos-arm64/flutter_embedding_debug.har does not exist.[39m
> hvigor [91mERROR: [31m00306053 Specification Limit Violation
[31mError Message: ohpm install failed.
[31m
* Try the following:
  > Verify the Internet connection.
  > Verify the repository address, package name, and version number.
[39m

[31m* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --debug option to get more log output.
[39m
> hvigor [91mERROR: BUILD FAILED in 2 s 384 ms [39m

0 task in total: 0 executed, 0 up-to-date.
===== flutter pub get =====
+ true
+ echo '===== flutter pub get ====='
+ cd /tmp/probe
+ flutter pub get
Resolving dependencies...
Downloading packages...
  clock 1.1.2 (1.1.3 available)
  cupertino_icons 1.0.9 (2.0.0 available)
  matcher 0.12.19 (0.12.20 available)
  material_color_utilities 0.13.0 (0.13.1 available)
  meta 1.17.0 (1.19.0 available)
  stack_trace 1.12.1 (1.12.2 available)
  test_api 0.7.10 (0.7.15 available)
  vector_math 2.2.0 (2.4.3 available)
Got dependencies!
8 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
+ echo '===== inject compileSdkVersion (same logic as entrypoint.sh) ====='
===== inject compileSdkVersion (same logic as entrypoint.sh) =====
++ jq -r '.data.platformVersion // empty' /opt/ohos-sdk/sdk/default/sdk-pkg.json
+ COMPILE_SDK=26.0.0
+ echo 'SDK platformVersion = 26.0.0'
SDK platformVersion = 26.0.0
+ perl -0pi -e 's{("compatibleSdkVersion"\s*:\s*"[^"]*",)}{"compileSdkVersion": "26.0.0",\n        $1}g' /tmp/probe/ohos/build-profile.json5
--- build-profile.json5 after injection ---
+ echo '--- build-profile.json5 after injection ---'
+ sed -n '/"products"/,/\]/p' /tmp/probe/ohos/build-profile.json5
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
        "compileSdkVersion": "26.0.0",
        "compatibleSdkVersion": "5.1.0(18)",
        "runtimeOS": "HarmonyOS",
      }
    ],
+ echo '===== flutter build hap --debug ====='
+ cd /tmp/probe
+ flutter build hap --debug
===== flutter build hap --debug =====
Downloading ohos-arm64-profile/linux-x64 tools...                2,930ms
Downloading ohos-arm64-release/linux-x64 tools...                   3.3s
Downloading ohos-x64-profile/linux-x64 tools...                    678ms
Downloading ohos-x64-release/linux-x64 tools...                    648ms
Downloading ohos-arm64 tools...                                     4.6s
Downloading ohos-arm64-profile tools...                          2,764ms
Downloading ohos-arm64-release tools...                          2,464ms
Downloading ohos-x64 tools...                                       4.5s
Downloading ohos-x64-profile tools...                               3.1s
Downloading ohos-x64-release tools...                            2,535ms
start hap build...
Running Hvigor task assembleHap...                                 23.7s
请通过DevEco Studio打开ohos工程后配置调试签名(File -> Project Structure -> Signing Configs 勾选Automatically generate signature)
===== artifacts =====
+ true
+ echo '===== artifacts ====='
+ find /tmp/probe/ohos -name '*.hap' -o -name '*.app'
/tmp/probe/ohos/entry/build/default/outputs/default/entry-default-unsigned.hap
===== df -h / =====
+ echo '===== df -h / ====='
+ df -h /
Filesystem      Size  Used Avail Use% Mounted on
overlay         145G   49G   96G  34% /
```

## image layout probe
```
--- ls /opt/ohos-sdk
total 268
drwx------ 11 root root   4096 Sep 21 23:20 .
drwxr-xr-x  1 root root   4096 Oct 10 19:06 ..
-rw-------  1 root root 106536 Sep 21 23:10 LICENSE.txt
-rw-------  1 root root 110759 Sep 21 23:10 NOTICE.txt
drwx------  5 root root   4096 Sep 21 23:13 arktsdoc
drwx------  2 root root   4096 Sep 21 23:19 bin
drwx------  5 root root   4096 Sep 21 23:15 codelinter
drwx------  8 root root   4096 Sep 21 23:10 emulator
drwx------  4 root root   4096 Sep 21 23:15 hstack
drwx------  5 root root   4096 Sep 21 23:19 hvigor
drwx------  6 root root   4096 Sep 21 23:11 ohpm
drwx------  3 root root   4096 Sep 21 23:14 sdk
drwx------  3 root root   4096 Sep 21 23:10 tool
-rw-------  1 root root    378 Sep 21 23:20 version.txt
--- ls sdk
total 12
drwx------  3 root root 4096 Sep 21 23:14 .
drwx------ 11 root root 4096 Sep 21 23:20 ..
drwx------  4 root root 4096 Sep 21 23:17 default
--- ls sdk/default
total 20
drwx------ 4 root root 4096 Sep 21 23:17 .
drwx------ 3 root root 4096 Sep 21 23:14 ..
drwxr-xr-x 7 root root 4096 Sep 16 00:30 hms
drwxr-xr-x 7 root root 4096 Sep 16 00:33 openharmony
-rw-r--r-- 1 root root  322 Sep 16 00:27 sdk-pkg.json
--- sdk-pkg.json
{
    "meta": {
        "version": "1.0.0"
    },
    "data": {
        "apiVersion": "26",
        "displayName": "HarmonyOS 26.0.0",
        "path": "HarmonyOS-26.0.0",
        "platformVersion": "26.0.0",
        "releaseType": "Release",
        "version": "26.0.0.105",
        "stage": "Release"
    }
}--- versions
6.26.8
26.0.0.630
dart-sdk-url: https://flutter-ohos.obs.cn-south-1.myhuaweicloud.com/flutter_infra_release/flutter/3fb08d34b6f96a15fbb219b903c9d0ab37b6c2e0/dart-sdk-linux-x64.zip
Downloading Linux x64 Dart SDK from Flutter engine 3fb08d34b6f96a15fbb219b903c9d0ab37b6c2e0...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0  0  193M    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0  0  193M    0  320k    0     0   180k      0  0:18:19  0:00:01  0:18:18  180k  0  193M    0 1920k    0     0   693k      0  0:04:45  0:00:02  0:04:43  693k  3  193M    3 7648k    0     0  1994k      0  0:01:39  0:00:03  0:01:36 1994k  6  193M    6 12.9M    0     0  2726k      0  0:01:12  0:00:04  0:01:08 2725k  9  193M    9 19.0M    0     0  3370k      0  0:00:58  0:00:05  0:00:53 3906k 13  193M   13 25.9M    0     0  3846k      0  0:00:51  0:00:06  0:00:45 5113k 16  193M   16 31.4M    0     0  4128k      0  0:00:48  0:00:07  0:00:41 6021k 19  193M   19 38.3M    0     0  4403k      0  0:00:45  0:00:08  0:00:37 6222k 22  193M   22 43.8M    0     0  4577k      0  0:00:43  0:00:09  0:00:34 6406k 26  193M   26 50.6M    0     0  4755k      0  0:00:41  0:00:10  0:00:31 6323k 29  193M   29 56.2M    0     0  4874k      0  0:00:40  0:00:11  0:00:29 6324k 31  193M   31 61.7M    0     0  4868k      0  0:00:40  0:00:12  0:00:28 5982k 34  193M   34 67.1M    0     0  4984k      0  0:00:39  0:00:13  0:00:26 6045k 37  193M   37 73.2M    0     0  5075k      0  0:00:39  0:00:14  0:00:25 6051k 41  193M   41 79.4M    0     0  5154k      0  0:00:38  0:00:15  0:00:23 6047k 43  193M   43 85.1M    0     0  5199k      0  0:00:38  0:00:16  0:00:22 5972k 47  193M   47 91.0M    0     0  5226k      0  0:00:37  0:00:17  0:00:20 6180k 49  193M   49 96.4M    0     0  5243k      0  0:00:37  0:00:18  0:00:19 5951k 53  193M   53  102M    0     0  5319k      0  0:00:37  0:00:19  0:00:18 6043k 56  193M   56  108M    0     0  5320k      0  0:00:37  0:00:20  0:00:17 5829k 59  193M   59  115M    0     0  5383k      0  0:00:36  0:00:21  0:00:15 5985k 61  193M   61  119M    0     0  5369k      0  0:00:36  0:00:22  0:00:14 5883k 63  193M   63  123M    0     0  5334k      0  0:00:37  0:00:23  0:00:14 5678k 66  193M   66  129M    0     0  5361k      0  0:00:36  0:00:24  0:00:12 5528k 70  193M   70  136M    0     0  5390k      0  0:00:36  0:00:25  0:00:11 5687k 73  193M   73  141M    0     0  5430k      0  0:00:36  0:00:26  0:00:10 5643k 76  193M   76  148M    0     0  5458k      0  0:00:36  0:00:27  0:00:09 5866k 79  193M   79  153M    0     0  5469k      0  0:00:36  0:00:28  0:00:08 6114k 82  193M   82  159M    0     0  5486k      0  0:00:36  0:00:29  0:00:07 6098k 85  193M   85  166M    0     0  5524k      0  0:00:35  0:00:30  0:00:05 6231k 89  193M   89  172M    0     0  5540k      0  0:00:35  0:00:31  0:00:04 6117k 92  193M   92  178M    0     0  5572k      0  0:00:35  0:00:32  0:00:03 6206k 95  193M   95  184M    0     0  5586k      0  0:00:35  0:00:33  0:00:02 6250k 98  193M   98  190M    0     0  5615k      0  0:00:35  0:00:34  0:00:01 6392k100  193M  100  193M    0     0  5621k      0  0:00:35  0:00:35 --:--:-- 6281k
Building flutter tool...
Resolving dependencies...
Downloading packages...
Got dependencies.
Flutter 3.41.10-ohos-1.0.1 • channel [user-branch] • unknown source
Framework • revision adaf911c35 (8 weeks ago) • 2026-08-17 17:01:32 +0700
Engine • hash 9161402dc0e134b3fb5adee5046b6e84b1a5e1c1 (revision 42d3d75a56) (5 months ago) • 2026-04-28 17:31:55.000Z
Tools • Dart 3.11.5 • DevTools 2.54.1
--- which
/opt/ohos-sdk/bin/hvigorw
/opt/ohos-sdk/bin/ohpm
```
