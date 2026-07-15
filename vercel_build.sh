#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "Downloading Flutter stable channel..."
git clone https://github.com/flutter/flutter.git -b stable

echo "Running flutter pub get..."
./flutter/bin/flutter pub get

echo "Building Flutter Web application..."
./flutter/bin/flutter build web --release

echo "Build complete! Output is in build/web"
