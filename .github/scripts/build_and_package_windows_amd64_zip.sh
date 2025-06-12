#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# ENV VARS
# ------------------------
FLUTTER_VERSION="3.32.0"
ARCH="amd64"
TAG_NAME="${1:-local}"
BUILD_DIR="$(pwd)/build/windows/${ARCH}/release/bundle"
OUTPUT_DIR="$(pwd)/artifacts/windows/${ARCH}/release/bundle"
ROOT_OUTPUT_DIR="$(pwd)/artifacts"
OUTPUT_NAME="PactusGUI-${TAG_NAME}-windows-${ARCH}.zip"
PACTUS_CLI_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_windows_amd64.zip"
FINAL_CLI_DEST="${BUILD_DIR}/data/flutter_assets/assets/native_resources/windows"

# ------------------------
# FUNCTION
# ------------------------

#install_flutter() {
#  echo "🔽 Cloning Flutter $FLUTTER_VERSION..."
#  git clone https://github.com/flutter/flutter.git --branch "$FLUTTER_VERSION" --depth 1
#  export PATH="$PWD/flutter/bin:$PATH"
#  flutter doctor -v
#  flutter config --enable-windows-desktop
#  flutter precache --windows
#}

build_flutter_windows() {
  echo "🔨 Building Flutter app for Windows ${ARCH}..."
  flutter pub get
  flutter build windows --release
}

download_and_extract_pactus_cli() {
  echo "⬇️ Downloading pactus-cli..."
  curl -sSL "$PACTUS_CLI_URL" -o pactus-cli.zip

  echo "📦 Extracting pactus-cli to ${FINAL_CLI_DEST}..."
  mkdir -p "$FINAL_CLI_DEST"
  unzip -q pactus-cli.zip -d "$FINAL_CLI_DEST"
}

package_release_zip() {
  echo "📦 Packaging final zip file (Windows)..."
  mkdir -p "$OUTPUT_DIR"
  ZIP_PATH="$OUTPUT_DIR/$OUTPUT_NAME"
  echo "📁 Zipping from: $BUILD_DIR"
  echo "📦 To: $ZIP_PATH"
  (
    cd "$BUILD_DIR"
    zip -r "$ZIP_PATH" .
  )
  echo "✅ Zip package saved to: $ZIP_PATH"

  echo "📁 Copying zip to artifacts root..."
  mkdir -p "$ROOT_OUTPUT_DIR"
  cp "$ZIP_PATH" "$ROOT_OUTPUT_DIR/"

  echo "📂 Listing copied zip:"
  ls -lh "$ROOT_OUTPUT_DIR/$OUTPUT_NAME"
}

# ------------------------
# MAIN
# ------------------------
#install_flutter
build_flutter_windows
download_and_extract_pactus_cli
package_release_zip
