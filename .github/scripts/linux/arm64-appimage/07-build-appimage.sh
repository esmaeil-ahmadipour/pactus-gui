#!/bin/bash
set -e

echo "🔧 ساخت AppImage آغاز شد..."

chmod +x ./linuxdeploy

# اجرای linuxdeploy از طریق QEMU
echo "🚀 اجرای linuxdeploy از طریق QEMU..."
qemu-aarch64 -L /usr/aarch64-linux-gnu ./linuxdeploy \
  --appdir AppDir \
  --desktop-file AppDir/pactus_gui.desktop \
  --icon-file AppDir/pactus_gui.png \
  --output appimage || true

# بررسی خروجی AppImage
if ls ./*.AppImage 1> /dev/null 2>&1; then
  TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "untagged")
  FILENAME="pactus_gui-${TAG}-arm64.AppImage"
  mv ./*.AppImage "$FILENAME"
  echo "✅ AppImage ساخته شد: $FILENAME"
  cp "$FILENAME" /output/
else
  echo "⚠️ AppImage با FUSE ساخته نشد، استفاده از --appimage-extract..."
  qemu-aarch64 -L /usr/aarch64-linux-gnu ./linuxdeploy \
    --appdir AppDir \
    --desktop-file AppDir/pactus_gui.desktop \
    --icon-file AppDir/pactus_gui.png \
    --output appimage --appimage-extract

  mkdir -p /output/extracted
  cp -r squashfs-root/* /output/extracted/
  echo "📦 محتویات AppImage در /output/extracted کپی شد"
fi

echo "✅ فرآیند ساخت AppImage تمام شد"



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