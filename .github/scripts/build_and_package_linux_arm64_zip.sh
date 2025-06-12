#!/usr/bin/env bash

set -euo pipefail

# ------------------------
# CONFIGURATION
# ------------------------

TAG_NAME="${1:-local}"
ARCH="arm64"
BUILD_DIR="$(pwd)/build/linux/arm64/release/bundle"
OUTPUT_DIR="$(pwd)/artifacts/linux/${ARCH}/release/bundle"
ROOT_OUTPUT_DIR="$(pwd)/artifacts"
OUTPUT_NAME="PactusGUI-${TAG_NAME}-linux-${ARCH}.zip"
PACTUS_CLI_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_linux_arm64.tar.gz"
FINAL_CLI_DEST="${BUILD_DIR}/lib/src/core/native_resources/linux"

# ------------------------
# FUNCTIONS
# ------------------------

install_dependencies() {
  echo "🔧 Installing dependencies..."
  sudo apt-get update
  sudo apt-get install -y wget unzip tree zip libgtk-3-dev cmake ninja-build
}

build_flutter_linux() {
  echo "🔨 Building Flutter app for Linux ${ARCH}..."
  flutter pub get
  flutter build linux --release
}

download_and_extract_pactus_cli() {
  echo "⬇️ Downloading pactus-cli..."
  wget -q "$PACTUS_CLI_URL" -O pactus-cli.tar.gz

  echo "📦 Extracting pactus-cli to ${FINAL_CLI_DEST}..."
  mkdir -p "$FINAL_CLI_DEST"
  tar -xzvf pactus-cli.tar.gz --strip-components=1 -C "$FINAL_CLI_DEST"
}

package_release_zip() {
  set -euo pipefail

  echo "📦 Starting ZIP packaging..."

  # Validate required directories
  if [[ -z "${BUILD_DIR:-}" || ! -d "$BUILD_DIR" ]]; then
    echo "❌ Error: BUILD_DIR '$BUILD_DIR' does not exist or is not set."
    exit 1
  fi

  if [[ -z "${OUTPUT_NAME:-}" ]]; then
    echo "❌ Error: OUTPUT_NAME is not set."
    exit 1
  fi

  # Prepare output paths
  mkdir -p "$OUTPUT_DIR"
  ZIP_PATH="$OUTPUT_DIR/$OUTPUT_NAME"

  echo "📁 Compressing contents of '$BUILD_DIR' into '$ZIP_PATH'..."
  cd "$BUILD_DIR"
  if ! zip -r --symlinks "$ZIP_PATH" . > /dev/null; then
    echo "❌ Error: Failed to create ZIP archive."
    exit 1
  fi
  cd - > /dev/null

  echo "✅ ZIP package created: $ZIP_PATH"

  # Copy to root artifacts directory
  mkdir -p "$ROOT_OUTPUT_DIR"
  cp -v "$ZIP_PATH" "$ROOT_OUTPUT_DIR/"

  echo "📤 ZIP file copied to artifacts directory: $ROOT_OUTPUT_DIR/"
}


# ------------------------
# MAIN
# ------------------------

install_dependencies
build_flutter_linux
download_and_extract_pactus_cli
package_release_zip
