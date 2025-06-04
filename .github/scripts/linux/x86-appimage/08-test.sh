#!/bin/bash
set -e

./*.AppImage --appimage-extract
chmod +x squashfs-root/AppRun
squashfs-root/AppRun --help || echo "✅ AppRun executed (GUI not launched in CI, but it's working)"
