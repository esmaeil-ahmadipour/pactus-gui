#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# ENVIRONMENT (تنظیمات)
# ------------------------

export FLUTTER_VERSION="3.32.0"
export TARGET_OS="windows"
export ARCH="amd64"
export FILE_TYPE="zip"

TAG_NAME="${1:-local}"

BUILD_DIR="$(pwd)/build/windows/x64/runner/Release"
OUTPUT_DIR="$(pwd)/artifacts/windows/${ARCH}/release"
ROOT_OUTPUT_DIR="$(pwd)/artifacts"
OUTPUT_NAME="PactusGUI-${TAG_NAME}-${TARGET_OS}-${ARCH}.${FILE_TYPE}"

PACTUS_CLI_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_windows_amd64.zip"
FINAL_CLI_DEST="${BUILD_DIR}/data/flutter_assets/lib/src/core/native_resources/windows"

# ------------------------
# FUNCTIONS
# ------------------------

install_dependencies() {
  echo "🔧 Installing dependencies (zip, curl)..."
  choco install zip curl -y || true
}

clone_flutter() {
  echo "⬇️ Cloning Flutter $FLUTTER_VERSION ..."
  git clone https://github.com/flutter/flutter.git --branch $FLUTTER_VERSION --depth 1
  export PATH="$PWD/flutter/bin:$PATH"
  flutter doctor -v
  flutter config --enable-windows-desktop
  flutter precache --windows
}

build_flutter_windows() {
  echo "🔨 Building Flutter app for Windows ${ARCH}..."
  flutter pub get
  flutter build windows --release
}

download_and_extract_pactus_cli() {
  echo "⬇️ Downloading pactus-cli..."
  curl -L -o pactus-cli.zip "$PACTUS_CLI_URL"

  echo "📦 Extracting pactus-cli to ${FINAL_CLI_DEST}..."
  mkdir -p "$FINAL_CLI_DEST"
  unzip -q pactus-cli.zip -d "$FINAL_CLI_DEST"
}

package_release_zip() {
  echo "📦 Packaging final zip file..."
  mkdir -p "$OUTPUT_DIR"
  ZIP_PATH="$OUTPUT_DIR/$OUTPUT_NAME"
  (
    cd "$BUILD_DIR"
    zip -r "$ZIP_PATH" .
  )
  echo "✅ Zip package saved to: $ZIP_PATH"

  echo "📁 Copying zip to artifacts root..."
  mkdir -p "$ROOT_OUTPUT_DIR"
  cp "$ZIP_PATH" "$ROOT_OUTPUT_DIR/"
}

# ------------------------
# MAIN
# ------------------------

install_dependencies
clone_flutter
build_flutter_windows
download_and_extract_pactus_cli
package_release_zip
