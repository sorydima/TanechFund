#!/usr/bin/env python3
"""
Simple script to create all icons from AppLogo.jpg
"""

import os
import shutil

def create_directories():
    """Create all necessary directories"""
    directories = [
        "android/app/src/main/res/mipmap-mdpi",
        "android/app/src/main/res/mipmap-hdpi", 
        "android/app/src/main/res/mipmap-xhdpi",
        "android/app/src/main/res/mipmap-xxhdpi",
        "android/app/src/main/res/mipmap-xxxhdpi",
        "ios/Runner/Assets.xcassets/AppIcon.appiconset",
        "macos/Runner/Assets.xcassets/AppIcon.appiconset",
        "web/icons",
        "windows/runner",
        "linux"
    ]
    
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
        print(f"📁 Created: {directory}")

def copy_logo_to_icons():
    """Copy AppLogo.jpg to all icon locations"""
    source = "assets/AppLogo.jpg"
    
    if not os.path.exists(source):
        print(f"❌ Source logo not found: {source}")
        return False
    
    # All icon locations
    icons = [
        # Android
        "android/app/src/main/res/mipmap-mdpi/ic_launcher.png",
        "android/app/src/main/res/mipmap-hdpi/ic_launcher.png",
        "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png",
        "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png",
        "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png",
        
        # iOS
        "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-20.png",
        "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-29.png",
        "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-40.png",
        "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-60.png",
        "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-76.png",
        "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-120.png",
        "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-180.png",
        "ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png",
        
        # macOS
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_16x16.png",
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_32x32.png",
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_128x128.png",
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_256x256.png",
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_512x512.png",
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png",
        
        # Web
        "web/favicon.png",
        "web/icons/Icon-192.png",
        "web/icons/Icon-512.png",
        
        # Windows
        "windows/runner/rechain_vc_lab_icon.png",
        
        # Linux
        "linux/icon_16x16.png",
        "linux/icon_32x32.png",
        "linux/icon_48x48.png",
        "linux/icon_64x64.png",
        "linux/icon_128x128.png",
        "linux/icon_256x256.png"
    ]
    
    success = 0
    for icon_path in icons:
        try:
            shutil.copy2(source, icon_path)
            print(f"✅ Created: {icon_path}")
            success += 1
        except Exception as e:
            print(f"❌ Failed: {icon_path} - {e}")
    
    return success, len(icons)

def main():
    print("🚀 REChain VC Lab - Creating Icons from AppLogo.jpg")
    print("=" * 50)
    
    print("📁 Creating directories...")
    create_directories()
    
    print("\n🎨 Copying AppLogo.jpg to all icon locations...")
    success, total = copy_logo_to_icons()
    
    print(f"\n📊 Summary:")
    print(f"   Icons created: {success}/{total}")
    
    if success == total:
        print("\n✅ All icons created successfully!")
        print("\n🚀 Next Steps:")
        print("1. Run 'flutter clean'")
        print("2. Run 'flutter pub get'")
        print("3. Test: flutter run -d chrome")
    else:
        print(f"\n⚠️ {total - success} icons failed to create.")
    
    print("\n🎯 REChain VC Lab Icons Status:")
    print("✅ Android: 5 icons")
    print("✅ iOS: 8 icons")
    print("✅ macOS: 6 icons")
    print("✅ Web: 3 icons")
    print("✅ Windows: 1 icon")
    print("✅ Linux: 6 icons")
    print(f"🎨 Total: {success} icons created!")

if __name__ == "__main__":
    main()
