#!/bin/bash
set -e

./linuxdeploy --appdir AppDir --desktop-file AppDir/pactus_gui.desktop --icon-file AppDir/pactus_gui.png --output appimage
chmod +x ./*.AppImage
