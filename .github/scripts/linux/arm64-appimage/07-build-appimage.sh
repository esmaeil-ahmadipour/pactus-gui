#!/bin/bash
set -e

# Install QEMU for ARM64 emulation
#sudo
apt-get update
#sudo
apt-get install -y qemu-user-static

# Make linuxdeploy executable
chmod +x linuxdeploy

# Run through QEMU
qemu-aarch64 -L /usr/aarch64-linux-gnu ./linuxdeploy \
  --appdir AppDir \
  --desktop-file AppDir/pactus_gui.desktop \
  --icon-file AppDir/pactus_gui.png \
  --output appimage

# Rename with ARM64 tag
TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "untagged")
mv ./*.AppImage "pactus_gui-${TAG}-arm64.AppImage"