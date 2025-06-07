#!/bin/bash

set -e

:contentReference[oaicite:1]{index=1}

# مطمئن شدن از executable بودن linuxdeploy
:contentReference[oaicite:2]{index=2}

# استفاده از QEMU، بدون نیاز به FUSE
:contentReference[oaicite:3]{index=3}
:contentReference[oaicite:4]{index=4}

:contentReference[oaicite:5]{index=5} \
  --appdir AppDir \
  :contentReference[oaicite:6]{index=6} \
  :contentReference[oaicite:7]{index=7} \
  --output appimage

# بررسی و انتقال خروجی
if ls ./*:contentReference[oaicite:8]{index=8}
  :contentReference[oaicite:9]{index=9}
  :contentReference[oaicite:10]{index=10}
  mv ./*.AppImage "$FILENAME"
  :contentReference[oaicite:11]{index=11}
  :contentReference[oaicite:12]{index=12}
else
  :contentReference[oaicite:13]{index=13}
  # :contentReference[oaicite:14]{index=14}
  :contentReference[oaicite:15]{index=15}
  :contentReference[oaicite:16]{index=16}
  :contentReference[oaicite:17]{index=17}
fi

:contentReference[oaicite:18]{index=18}


#set -e
#
#echo "🔧 ساخت AppImage آغاز شد..."
#
#chmod +x ./linuxdeploy
#
## اجرای linuxdeploy از طریق QEMU
#echo "🚀 اجرای linuxdeploy از طریق QEMU..."
#qemu-aarch64 -L /usr/aarch64-linux-gnu ./linuxdeploy \
#  --appdir AppDir \
#  --desktop-file AppDir/pactus_gui.desktop \
#  --icon-file AppDir/pactus_gui.png \
#  --output appimage || true
#
## بررسی خروجی AppImage
#if ls ./*.AppImage 1> /dev/null 2>&1; then
#  TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "untagged")
#  FILENAME="pactus_gui-${TAG}-arm64.AppImage"
#  mv ./*.AppImage "$FILENAME"
#  echo "✅ AppImage ساخته شد: $FILENAME"
#  cp "$FILENAME" /output/
#else
#  echo "⚠️ AppImage با FUSE ساخته نشد، استفاده از --appimage-extract..."
#  qemu-aarch64 -L /usr/aarch64-linux-gnu ./linuxdeploy \
#    --appdir AppDir \
#    --desktop-file AppDir/pactus_gui.desktop \
#    --icon-file AppDir/pactus_gui.png \
#    --output appimage --appimage-extract
#
#  mkdir -p /output/extracted
#  cp -r squashfs-root/* /output/extracted/
#  echo "📦 محتویات AppImage در /output/extracted کپی شد"
#fi
#
#echo "✅ فرآیند ساخت AppImage تمام شد"



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