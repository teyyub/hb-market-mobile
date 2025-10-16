#!/bin/bash

echo "Cleaning previous builds..."
flutter clean

echo "Getting dependencies..."
flutter pub get

# Android
echo "Building Android APK..."
flutter build apk --release
echo "Android APK is in build/app/outputs/flutter-apk/app-release.apk"

# iOS
echo "Building iOS app..."
flutter build ios --release
echo "iOS build done. Open ios/Runner.xcworkspace in Xcode to sign and deploy."

# Web
echo "Building Web app..."
flutter build web --release
echo "Web build is in build/web"

echo "All builds completed!"
