#!/bin/bash
set -e

# Set tag and architecture
TAG_NAME=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.7.1")
ARCH="arm64"
LINUX_ASSETS_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_linux_amd64.tar.gz"

echo "📌 Using TAG_NAME=$TAG_NAME"

# Download the daemon archive
echo "⬇️ Downloading daemon file from $LINUX_ASSETS_URL ..."
curl -fL -o file.tar.gz "$LINUX_ASSETS_URL"

# Extract to native resource path
DEST="artifacts/linux/${ARCH}/release/bundle/usr/bin/lib/src/core/native_resources/linux/"
mkdir -p "$DEST"
echo "📦 Extracting to: $DEST"
tar -xvzf file.tar.gz --strip-components=1 -C "$DEST"

echo "✅ Daemon extracted."

# Ensure the AppImage exists before attempting upload
APPIMAGE_FILE=$(find artifacts/linux/${ARCH}/release/bundle -maxdepth 1 -name "*.AppImage" | head -n 1)

if [[ -f "$APPIMAGE_FILE" ]]; then
  echo "📤 Found AppImage: $APPIMAGE_FILE"
else
  echo "❌ No .AppImage file found!"
  exit 1
fi
