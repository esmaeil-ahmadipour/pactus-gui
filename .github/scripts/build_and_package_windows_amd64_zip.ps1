param (
    [string]$TagName = "local"
)

$ARCH = "amd64"
$BUILD_DIR = Join-Path (Get-Location) "build\windows\runner\Release"
$OUTPUT_DIR = Join-Path (Get-Location) "artifacts\windows\$ARCH\release"
$ROOT_OUTPUT_DIR = Join-Path (Get-Location) "artifacts"
$OUTPUT_NAME = "PactusGUI-$TagName-windows-$ARCH.zip"
$PACTUS_CLI_URL = "https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_windows_amd64.zip"
$FINAL_CLI_DEST = Join-Path $BUILD_DIR "data\flutter_assets\assets\core\native_resources\windows"

Write-Host "🔧 Installing dependencies (if needed)..."
# On windows-latest, necessary dependencies are already present usually

Write-Host "🔨 Building Flutter app for Windows..."
flutter pub get
flutter build windows --release

Write-Host "⬇️ Downloading pactus-cli..."
Invoke-WebRequest -Uri $PACTUS_CLI_URL -OutFile "pactus-cli.zip"

Write-Host "📦 Extracting pactus-cli..."
New-Item -ItemType Directory -Force -Path $FINAL_CLI_DEST | Out-Null
Expand-Archive -Path "pactus-cli.zip" -DestinationPath $FINAL_CLI_DEST -Force

Write-Host "📦 Packaging final zip file..."
New-Item -ItemType Directory -Force -Path $OUTPUT_DIR | Out-Null
$ZIP_PATH = Join-Path $OUTPUT_DIR $OUTPUT_NAME
Compress-Archive -Path "$BUILD_DIR\*" -DestinationPath $ZIP_PATH

Write-Host "✅ Zip package saved to: $ZIP_PATH"

Write-Host "📁 Copying zip to artifacts root..."
New-Item -ItemType Directory -Force -Path $ROOT_OUTPUT_DIR | Out-Null
Copy-Item -Path $ZIP_PATH -Destination $ROOT_OUTPUT_DIR -Force
