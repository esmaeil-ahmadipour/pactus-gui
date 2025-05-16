#!/bin/bash
set -e

# Set TAG and default value
TAG_NAME=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.7.1")
ARCH="arm64"
LINUX_ASSETS_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_linux_amd64.tar.gz"

echo "📌 Using TAG_NAME=$TAG_NAME"

# Download files
echo "⬇️ Downloading daemon file from $LINUX_ASSETS_URL ..."
curl -L -o file.tar.gz "$LINUX_ASSETS_URL"

# Extract to destination
DEST="artifacts/linux/${ARCH}/release/bundle/usr/bin/lib/src/core/native_resources/linux/"
mkdir -p "$DEST"
echo "📦 Extracting to: $DEST"
tar -xvzf file.tar.gz --strip-components=1 -C "$DEST"

# Create AppImage
cd "artifacts/linux/${ARCH}/release/bundle"
FILE_NAME="linux-build-${ARCH}-${TAG_NAME}.AppImage"
echo "🖼️ Creating AppImage: $FILE_NAME"

# Ensure the main executable has execute permissions
chmod +x usr/bin/lib/src/core/native_resources/linux/*

# Rename the generated AppImage to our desired filename
mv *.AppImage "$FILE_NAME"

echo "✅ Done. Output AppImage: $FILE_NAME"