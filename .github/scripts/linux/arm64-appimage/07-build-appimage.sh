#!/bin/bash
set -e

echo "🔍 Current directory: $(pwd)"
echo "📦 Installing debugging tools..."
apt-get update && apt-get install -y qemu-user-static tree

echo "📁 Tree view:"
tree -a -L 3 || echo "⚠️ tree failed or too deep"

echo "📂 Checking AppDir..."
if [ ! -d "AppDir" ]; then
  echo "❌ AppDir missing!"
  exit 1
fi

echo "📑 Checking .desktop and .png..."
if [ ! -f "AppDir/pactus_gui.desktop" ]; then
  echo "❌ Missing pactus_gui.desktop"
  exit 1
fi

if [ ! -f "AppDir/pactus_gui.png" ]; then
  echo "❌ Missing pactus_gui.png"
  exit 1
fi

echo "🔧 Making linuxdeploy executable..."
chmod +x linuxdeploy

echo "🚀 Running linuxdeploy..."
qemu-aarch64 -L /usr/aarch64-linux-gnu ./linuxdeploy \
  --appdir AppDir \
  --desktop-file AppDir/pactus_gui.desktop \
  --icon-file AppDir/pactus_gui.png \
  --output appimage

TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "untagged")
APPIMAGE_FILE="pactus_gui-${TAG}-arm64.AppImage"

echo "📦 Renaming AppImage to: $APPIMAGE_FILE"
mv ./*.AppImage "$APPIMAGE_FILE"

# اطمینان از اینکه فایل خارج داکر هم قابل دسترسه
echo "📤 AppImage should now be available outside Docker under: $APPIMAGE_FILE"


##!/bin/bash
#set -e
#
## Install QEMU for ARM64 emulation
##sudo
#apt-get update
##sudo
#apt-get install -y qemu-user-static
#
## Make linuxdeploy executable
#chmod +x linuxdeploy
#
## Run through QEMU
#qemu-aarch64 -L /usr/aarch64-linux-gnu ./linuxdeploy \
#  --appdir AppDir \
#  --desktop-file AppDir/pactus_gui.desktop \
#  --icon-file AppDir/pactus_gui.png \
#  --output appimage
#
## Rename with ARM64 tag
#TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "untagged")
#mv ./*.AppImage "pactus_gui-${TAG}-arm64.AppImage"