#!/bin/bash

# Build script for Claude Usage menubar app

APP_NAME="ClaudeUsage"
BUILD_DIR="build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"

echo "Building ${APP_NAME}..."

# Create build directory structure
mkdir -p "${BUILD_DIR}"
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"

# Generate app icon
echo "Generating app icon..."
./generate-icon.sh
if [ $? -ne 0 ]; then
    echo "Warning: Failed to generate icon, continuing without it"
fi

# Copy icon if it exists
if [ -f "${BUILD_DIR}/AppIcon.icns" ]; then
    cp "${BUILD_DIR}/AppIcon.icns" "${APP_BUNDLE}/Contents/Resources/"
fi

# Copy Info.plist
cp Info.plist "${APP_BUNDLE}/Contents/"

# Inject version from VERSION file — single source of truth, never hardcode in Info.plist
APP_VERSION=$(cat VERSION 2>/dev/null | tr -d '[:space:]')
if [ -n "$APP_VERSION" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${APP_VERSION}" "${APP_BUNDLE}/Contents/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${APP_VERSION}" "${APP_BUNDLE}/Contents/Info.plist"
    echo "Version: ${APP_VERSION}"
else
    echo "Warning: VERSION file missing — Info.plist version unchanged"
fi

# Compile the Swift app
swiftc ClaudeUsageApp.swift \
    -o "${APP_BUNDLE}/Contents/MacOS/${APP_NAME}" \
    -framework Cocoa \
    -framework SwiftUI \
    -framework Security \
    -parse-as-library

if [ $? -eq 0 ]; then
    # Ad-hoc sign so the binary has a stable identity across sessions (prevents keychain re-prompts)
    codesign --force --sign - "${APP_BUNDLE}" 2>/dev/null && echo "App signed (ad-hoc)." || echo "Warning: codesign failed, continuing anyway."
    echo "Build successful! App bundle created at ${APP_BUNDLE}"
    echo ""
    echo "To run the app:"
    echo "  ./run.sh"
    echo ""
    echo "Or open it directly:"
    echo "  open ${APP_BUNDLE}"
else
    echo "Build failed!"
    exit 1
fi
