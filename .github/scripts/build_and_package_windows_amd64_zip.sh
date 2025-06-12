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
  echo ""
  echo "🟢=============================="
  echo "🟢 Packaging final zip file (Windows)"
  echo "🟢=============================="

  # 🟩 پیدا کردن مسیر Build به‌صورت داینامیک
  echo "🔍 Looking for Windows release build directory..."
  BUILD_DIR=$(find "$(pwd)/build/windows" -type d -path "*/release/bundle" | head -n 1)

  if [[ -z "$BUILD_DIR" ]]; then
    echo "❌ ERROR: Could not find build output directory!"
    exit 1
  fi

  echo "✅ Found build directory:"
  echo "   📁 $BUILD_DIR"
  echo ""

  # 🟩 تعریف مسیرها
  OUTPUT_DIR="$(pwd)/artifacts/windows/release/bundle"
  ROOT_OUTPUT_DIR="$(pwd)/artifacts"
  TAG_NAME="${1:-local}"
  OUTPUT_NAME="PactusGUI-${TAG_NAME}-windows.zip"
  ZIP_PATH="$OUTPUT_DIR/$OUTPUT_NAME"

  # 🟩 تبدیل مسیرها به سبک Windows برای PowerShell
  BUILD_DIR_WIN=$(cd "$BUILD_DIR" && pwd -W)
  ZIP_PATH_WIN=$(cd "$(dirname "$ZIP_PATH")" && pwd -W)\\$(basename "$ZIP_PATH")

  echo "📁 BUILD_DIR (Win-style): $BUILD_DIR_WIN"
  echo "📦 ZIP will be created at (Win-style): $ZIP_PATH_WIN"
  echo ""

  # 🟩 محتوای پوشه‌ی Build رو چاپ کن برای شفافیت
  echo "📂 Listing content of build directory:"
  ls -al "$BUILD_DIR"
  echo ""

  # 🟩 فشرده‌سازی با PowerShell
  echo "🛠 Compressing files..."
  mkdir -p "$OUTPUT_DIR"
  powershell.exe -Command "Compress-Archive -Path '${BUILD_DIR_WIN}\\*' -DestinationPath '${ZIP_PATH_WIN}' -Force"
  echo ""

  echo "✅ Zip package created successfully:"
  echo "   📦 $ZIP_PATH"

  # 🟩 کپی به پوشه‌ی ریشه‌ی artifacts
  echo "📁 Copying ZIP to root artifacts directory..."
  mkdir -p "$ROOT_OUTPUT_DIR"
  cp "$ZIP_PATH" "$ROOT_OUTPUT_DIR/"

  echo ""
  echo "🎉 Done! Artifact available at:"
  echo "   👉 $ROOT_OUTPUT_DIR/$(basename "$ZIP_PATH")"
  echo ""
}



# ------------------------
# MAIN
# ------------------------
#install_flutter
build_flutter_windows
download_and_extract_pactus_cli
package_release_zip
