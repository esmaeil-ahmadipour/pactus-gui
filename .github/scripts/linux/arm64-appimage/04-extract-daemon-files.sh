#!/bin/bash
set -e

# Set TAG and default value
TAG_NAME=$(git describe --tags --abbrev=0 2>/dev/null || echo "untagged")
ARCH="arm64"

# Set default URL if LINUX_ASSETS_URL is empty/unset
DEFAULT_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_linux_arm64.tar.gz"
DOWNLOAD_URL="${LINUX_ASSETS_URL:-$DEFAULT_URL}"

echo "📌 Using TAG_NAME=$TAG_NAME"

# Download files
echo "⬇️ Downloading ARM64 daemon file from $DOWNLOAD_URL ..."
curl -L -o daemon-arm64-appimage.tar.gz "$DOWNLOAD_URL"

# Extract to destination
DEST="build/linux/arm64/release/bundle/lib/src/core/native_resources/linux/"
mkdir -p "$DEST"
echo "📦 Extracting to: $DEST"
tar -xvzf daemon-arm64-appimage.tar.gz --strip-components=1 -C "$DEST"
 echo "✅ Done. Output AppImage for arm64"