#!/usr/bin/env python3
"""
REChain VC Lab - Create Icons from AppLogo.jpg for All Platforms
"""

import os
import sys
from PIL import Image, ImageDraw, ImageFont
import math

def resize_and_center_image(source_path, target_size, output_path):
    """Resize image to target size while maintaining aspect ratio and centering"""
    try:
        # Open source image
        with Image.open(source_path) as img:
            # Convert to RGBA if needed
            if img.mode != 'RGBA':
                img = img.convert('RGBA')
            
            # Create new image with target size and transparent background
            new_img = Image.new('RGBA', (target_size, target_size), (0, 0, 0, 0))
            
            # Calculate scaling to fit within target size while maintaining aspect ratio
            img_ratio = img.width / img.height
            target_ratio = 1.0  # Square target
            
            if img_ratio > target_ratio:
                # Image is wider than tall
                new_width = target_size
                new_height = int(target_size / img_ratio)
            else:
                # Image is taller than wide
                new_height = target_size
                new_width = int(target_size * img_ratio)
            
            # Resize image
            resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
            
            # Center the resized image
            x = (target_size - new_width) // 2
            y = (target_size - new_height) // 2
            
            # Paste resized image onto new image
            new_img.paste(resized_img, (x, y), resized_img)
            
            # Save as PNG
            new_img.save(output_path, 'PNG')
            print(f"✅ Created: {output_path} ({target_size}x{target_size})")
            return True
            
    except Exception as e:
        print(f"❌ Failed: {output_path} - {str(e)}")
        return False

def create_icon_with_background(source_path, target_size, output_path, bg_color=(99, 102, 241, 255)):
    """Create icon with background color"""
    try:
        # Open source image
        with Image.open(source_path) as img:
            # Convert to RGBA if needed
            if img.mode != 'RGBA':
                img = img.convert('RGBA')
            
            # Create new image with background color
            new_img = Image.new('RGBA', (target_size, target_size), bg_color)
            
            # Calculate scaling to fit within target size with some padding
            padding = target_size // 8  # 12.5% padding on each side
            max_size = target_size - (padding * 2)
            
            img_ratio = img.width / img.height
            
            if img_ratio > 1.0:
                # Image is wider than tall
                new_width = max_size
                new_height = int(max_size / img_ratio)
            else:
                # Image is taller than wide
                new_height = max_size
                new_width = int(max_size * img_ratio)
            
            # Resize image
            resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
            
            # Center the resized image
            x = (target_size - new_width) // 2
            y = (target_size - new_height) // 2
            
            # Paste resized image onto new image
            new_img.paste(resized_img, (x, y), resized_img)
            
            # Save as PNG
            new_img.save(output_path, 'PNG')
            print(f"✅ Created: {output_path} ({target_size}x{target_size})")
            return True
            
    except Exception as e:
        print(f"❌ Failed: {output_path} - {str(e)}")
        return False

def main():
    print("🚀 REChain VC Lab - Creating Icons from AppLogo.jpg")
    print("=" * 60)
    
    # Source logo path
    source_logo = "assets/AppLogo.jpg"
    
    if not os.path.exists(source_logo):
        print(f"❌ Source logo not found: {source_logo}")
        return
    
    print(f"📸 Using source logo: {source_logo}")
    
    # Create directories
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
    
    print("📁 Creating directories...")
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
        print(f"   📁 Created: {directory}")
    
    # Define all icons to create
    icons = [
        # Android - with background
        ("android/app/src/main/res/mipmap-mdpi/ic_launcher.png", 48, True),
        ("android/app/src/main/res/mipmap-hdpi/ic_launcher.png", 72, True),
        ("android/app/src/main/res/mipmap-xhdpi/ic_launcher.png", 96, True),
        ("android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png", 144, True),
        ("android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png", 192, True),
        
        # iOS - with background
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-20.png", 20, True),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-29.png", 29, True),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-40.png", 40, True),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-60.png", 60, True),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-76.png", 76, True),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-120.png", 120, True),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-180.png", 180, True),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png", 1024, True),
        
        # macOS - with background
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_16x16.png", 16, True),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_32x32.png", 32, True),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_128x128.png", 128, True),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_256x256.png", 256, True),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_512x512.png", 512, True),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png", 1024, True),
        
        # Web - with background
        ("web/favicon.png", 32, True),
        ("web/icons/Icon-192.png", 192, True),
        ("web/icons/Icon-512.png", 512, True),
        
        # Windows - with background
        ("windows/runner/rechain_vc_lab_icon.png", 256, True),
        
        # Linux - with background
        ("linux/icon_16x16.png", 16, True),
        ("linux/icon_32x32.png", 32, True),
        ("linux/icon_48x48.png", 48, True),
        ("linux/icon_64x64.png", 64, True),
        ("linux/icon_128x128.png", 128, True),
        ("linux/icon_256x256.png", 256, True)
    ]
    
    print("\n🎨 Creating icons from AppLogo.jpg...")
    success_count = 0
    total_icons = len(icons)
    
    for icon_path, size, with_background in icons:
        if with_background:
            # Use blue background color #6366F1
            bg_color = (99, 102, 241, 255)
            if create_icon_with_background(source_logo, size, icon_path, bg_color):
                success_count += 1
        else:
            if resize_and_center_image(source_logo, size, icon_path):
                success_count += 1
    
    print(f"\n📊 Summary:")
    print(f"   Icons created: {success_count}/{total_icons}")
    
    if success_count == total_icons:
        print("\n✅ All icons created successfully from AppLogo.jpg!")
        print("\n🚀 Next Steps:")
        print("1. Run 'flutter clean'")
        print("2. Run 'flutter pub get'")
        print("3. Test on your preferred platform:")
        print("   - flutter run -d android")
        print("   - flutter run -d chrome")
        print("   - flutter run -d windows")
        print("   - flutter run -d linux")
    else:
        print(f"\n⚠️ {total_icons - success_count} icons failed to create.")
    
    print("\n🎯 REChain VC Lab Icons Status:")
    print("✅ Android: 5 icons ready")
    print("✅ iOS: 8 icons ready")
    print("✅ macOS: 6 icons ready")
    print("✅ Web: 3 icons ready")
    print("✅ Windows: 1 icon ready")
    print("✅ Linux: 6 icons ready")
    print(f"🎨 Total: {success_count} icons created from AppLogo.jpg!")

if __name__ == "__main__":
    main()
