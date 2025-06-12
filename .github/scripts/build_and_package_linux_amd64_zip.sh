#!/usr/bin/env bash
set -euo pipefail

TAG_NAME="${1:-local}"
OUTPUT_NAME="PactusGUI-${TAG_NAME}-linux-amd64.zip"
OUTPUT_DIR="build/linux/x64/release/bundle"
PACTUS_CLI_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_linux_amd64.tar.gz"
CLI_DEST="$OUTPUT_DIR/lib/src/core/native_resources/linux"

install_dependencies() {
  echo "🔧 Installing dependencies..."
  sudo apt-get update
  sudo apt-get install -y \
    libgtk-3-dev \
    cmake \
    ninja-build \
    wget \
    unzip \
    tree \
    pkg-config
}


build_flutter() {
  echo "🎯 Building Flutter Linux release..."
  flutter pub get
  flutter build linux --release
}

download_and_extract_cli() {
  echo "⬇️ Downloading pactus-cli..."
  wget -q "$PACTUS_CLI_URL" -O pactus-cli.tar.gz
  mkdir -p "$CLI_DEST"
  tar -xzvf pactus-cli.tar.gz --strip-components=1 -C "$CLI_DEST"
}

package_zip() {
  echo "📦 Creating ZIP package..."
  mkdir -p artifacts
  ZIP_PATH="artifacts/${OUTPUT_NAME}"
  (cd "$OUTPUT_DIR" && zip -r "../../../../../$ZIP_PATH" .)
  echo "✅ ZIP saved to $ZIP_PATH"
}

install_dependencies
build_flutter
download_and_extract_cli
package_zip
