#!/bin/bash
set -e

sudo apt update

sudo apt install -y libfuse2 build-essential patchelf wget zsync squashfs-tools \
  libgtk-3-dev libglib2.0-dev libnss3 libxss1 libx11-dev \
  tar gzip libssl-dev unzip qemu-user-static cmake ninja-build clang

# Replace problematic libasound2 with real provider
sudo apt install -y libasound2t64 || sudo apt install -y liboss4-salsa-asound2

# Register emulators (required if building inside docker)
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# ARM64 compatible tools
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-aarch64.AppImage -O linuxdeploy

# Make linuxdeploy executable
chmod +x linuxdeploy

# Run with QEMU (assuming linuxdeploy is ARM64 binary)
qemu-aarch64 ./linuxdeploy --appdir AppDir ...
