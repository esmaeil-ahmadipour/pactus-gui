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
  echo "📦 Packaging final zip file..."

  mkdir -p "$OUTPUT_DIR"
  mkdir -p "$ROOT_OUTPUT_DIR"

  ZIP_PATH="$OUTPUT_DIR/$OUTPUT_NAME"
  cd "$BUILD_DIR"

  echo "📁 Zipping contents of: $BUILD_DIR"

  # استفاده از zip در Git Bash
  if command -v zip &> /dev/null; then
    zip -r "$ZIP_PATH" ./*
  else
    # اگر zip نصب نیست، از tar استفاده کنید
    tar -a -cvf "$ZIP_PATH" -- *
  fi

  echo "✅ Zip package saved to: $ZIP_PATH"

  echo "📁 Copying zip to artifacts root..."
  cp "$ZIP_PATH" "$ROOT_OUTPUT_DIR/"
  echo "✅ Zip package copy to: $ROOT_OUTPUT_DIR"
  ls -lh "$ROOT_OUTPUT_DIR"

  echo "📂 Listing artifacts:"
  ls -lh "$OUTPUT_DIR"
  ls -lh "$ROOT_OUTPUT_DIR"
}

# ------------------------
# MAIN
# ------------------------
build_flutter_windows
download_and_extract_pactus_cli
package_release_zip