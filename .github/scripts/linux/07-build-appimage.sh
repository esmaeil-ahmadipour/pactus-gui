#!/bin/bash
set -e

./linuxdeploy --appdir AppDir --desktop-file AppDir/pactus_gui.desktop --icon-file AppDir/pactus_gui.png --output appimage

# Dynamic naming with version/tag
TAG=$(git describe --tags --abbrev=0 2>/dev/null)
ARCH="x86_64"
FILE_NAME= "pactus_gui-${TAG}-${ARCH}.AppImage"

mv ./*.AppImage FILE_NAME

chmod +x ./*.AppImage
