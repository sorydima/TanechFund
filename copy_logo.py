#!/usr/bin/env python3
import os
import shutil

# Create directories
dirs = [
    "ios/Runner/Assets.xcassets/AppIcon.appiconset",
    "macos/Runner/Assets.xcassets/AppIcon.appiconset", 
    "web/icons",
    "windows/runner",
    "linux"
]

for d in dirs:
    os.makedirs(d, exist_ok=True)
    print(f"Created: {d}")

# Copy logo to all locations
source = "assets/AppLogo.jpg"
icons = [
    "android/app/src/main/res/mipmap-mdpi/ic_launcher.png",
    "android/app/src/main/res/mipmap-hdpi/ic_launcher.png",
    "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png",
    "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png",
    "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png",
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-20.png",
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-29.png",
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-40.png",
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-60.png",
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-76.png",
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-120.png",
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-180.png",
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png",
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_16x16.png",
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_32x32.png",
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_128x128.png",
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_256x256.png",
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_512x512.png",
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png",
    "web/favicon.png",
    "web/icons/Icon-192.png",
    "web/icons/Icon-512.png",
    "windows/runner/rechain_vc_lab_icon.png",
    "linux/icon_16x16.png",
    "linux/icon_32x32.png",
    "linux/icon_48x48.png",
    "linux/icon_64x64.png",
    "linux/icon_128x128.png",
    "linux/icon_256x256.png"
]

success = 0
for icon in icons:
    try:
        shutil.copy2(source, icon)
        print(f"✅ {icon}")
        success += 1
    except Exception as e:
        print(f"❌ {icon}: {e}")

print(f"\nCreated {success}/{len(icons)} icons")
print("Run: flutter clean && flutter pub get && flutter run -d chrome")
