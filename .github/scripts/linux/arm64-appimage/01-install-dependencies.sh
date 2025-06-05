#!/bin/bash
set -e

echo "🔧 Updating system and installing dependencies..."
#sudo
apt update

#sudo
apt install -y \
  libfuse2 build-essential patchelf wget zsync squashfs-tools \
  libgtk-3-dev libglib2.0-dev libnss3 libxss1 libx11-dev \
  tar gzip libssl-dev unzip qemu-user-static cmake ninja-build clang

# Handle audio library (libasound2) compatibility
echo "🎵 Installing libasound2 or fallback alternative..."
#sudo
apt install -y libasound2 || apt install -y liboss4-salsa-asound2

# Ensure qemu-aarch64 is available via symlink
if ! command -v qemu-aarch64 &> /dev/null && command -v qemu-aarch64-static &> /dev/null; then
  echo "🔗 Linking qemu-aarch64-static to qemu-aarch64"
  #sudo
  ln -s /usr/bin/qemu-aarch64-static /usr/bin/qemu-aarch64
fi

# Confirm qemu is available
echo "✅ Using QEMU binary at: $(which qemu-aarch64)"

# Download ARM64-compatible linuxdeploy
echo "⬇️ Downloading linuxdeploy for ARM64..."
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-aarch64.AppImage -O linuxdeploy

chmod +x linuxdeploy
echo "✅ linuxdeploy downloaded and made executable."

# Test execution through QEMU
echo "🧪 Testing linuxdeploy via qemu-aarch64..."
qemu-aarch64 ./linuxdeploy --appimage-extract || {
  echo "❌ Failed to execute linuxdeploy via QEMU."
  exit 1
}
