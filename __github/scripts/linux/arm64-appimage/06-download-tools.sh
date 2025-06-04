#!/bin/bash
set -e

# ARM64 compatible tools
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-aarch64.AppImage -O linuxdeploy
chmod +x linuxdeploy