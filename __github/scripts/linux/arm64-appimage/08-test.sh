#!/bin/bash
set -e

# Test ARM64 AppImage in emulator if needed
qemu-aarch64 ./*arm64*.AppImage --appimage-extract
chmod +x squashfs-root/AppRun
squashfs-root/AppRun --version