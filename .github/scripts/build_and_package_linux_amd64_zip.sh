#!/usr/bin/env bash

set -euo pipefail

# ------------------------
# CONFIGURATION
# ------------------------

TAG_NAME="${1:-local}"
OUTPUT_NAME="PactusGUI-${TAG_NAME}-linux-amd64.zip"
OUTPUT_DIR="artifacts/linux/amd64/release/bundle"
PACTUS_CLI_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_linux_amd64.tar.gz"
FINAL_CLI_DEST="build/linux/x64/release/bundle/lib/src/core/native_resources/linux"

# ------------------------
# FUNCTIONS
# ------------------------

install_dependencies() {
  echo "🔧 Installing dependencies..."
  sudo apt-get update
  sudo apt-get install -y wget unzip tree zip libgtk-3-dev cmake ninja-build
}

build_flutter_linux() {
  echo "🔨 Building Flutter app for Linux AMD64..."
  flutter pub get
  flutter build linux --release
}

download_and_extract_pactus_cli() {
  echo "⬇️ Downloading pactus-cli..."
  wget -q "$PACTUS_CLI_URL" -O pactus-cli.tar.gz

  echo "📦 Extracting pactus-cli to $FINAL_CLI_DEST..."
  mkdir -p "$FINAL_CLI_DEST"
  tar -xzvf pactus-cli.tar.gz --strip-components=1 -C "$FINAL_CLI_DEST"
}

package_release_zip() {
  echo "📦 Packaging final zip file..."
  mkdir -p "$(dirname "$OUTPUT_DIR/$OUTPUT_NAME")"

  pushd build/linux/x64/release > /dev/null
  zip -r "../../../${OUTPUT_DIR}/${OUTPUT_NAME}" bundle/
  popd > /dev/null

  echo "✅ Zip package saved to ${OUTPUT_DIR}/${OUTPUT_NAME}"
}

# ------------------------
# MAIN
# ------------------------

install_dependencies
build_flutter_linux
download_and_extract_pactus_cli
package_release_zip
