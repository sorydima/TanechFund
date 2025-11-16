#!/usr/bin/env python3
"""
Copy AppLogo.jpg to all icon locations with proper sizing
"""

import os
import shutil
from PIL import Image

def create_icon_from_logo(source_path, target_path, size):
    """Create icon by resizing the logo"""
    try:
        # Open source image
        with Image.open(source_path) as img:
            # Convert to RGBA if needed
            if img.mode != 'RGBA':
                img = img.convert('RGBA')
            
            # Create new image with target size
            new_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
            
            # Calculate scaling to fit within target size with padding
            padding = size // 8  # 12.5% padding
            max_size = size - (padding * 2)
            
            # Calculate new dimensions maintaining aspect ratio
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
            x = (size - new_width) // 2
            y = (size - new_height) // 2
            
            # Paste resized image onto new image
            new_img.paste(resized_img, (x, y), resized_img)
            
            # Ensure directory exists
            os.makedirs(os.path.dirname(target_path), exist_ok=True)
            
            # Save as PNG
            new_img.save(target_path, 'PNG')
            print(f"✅ Created: {target_path} ({size}x{size})")
            return True
            
    except Exception as e:
        print(f"❌ Failed: {target_path} - {str(e)}")
        return False

def main():
    print("🚀 REChain VC Lab - Creating Icons from AppLogo.jpg")
    print("=" * 50)
    
    source_logo = "assets/AppLogo.jpg"
    
    if not os.path.exists(source_logo):
        print(f"❌ Source logo not found: {source_logo}")
        return
    
    # All icons to create
    icons = [
        # Android
        ("android/app/src/main/res/mipmap-mdpi/ic_launcher.png", 48),
        ("android/app/src/main/res/mipmap-hdpi/ic_launcher.png", 72),
        ("android/app/src/main/res/mipmap-xhdpi/ic_launcher.png", 96),
        ("android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png", 144),
        ("android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png", 192),
        
        # iOS
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-20.png", 20),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-29.png", 29),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-40.png", 40),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-60.png", 60),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-76.png", 76),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-120.png", 120),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-180.png", 180),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png", 1024),
        
        # macOS
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_16x16.png", 16),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_32x32.png", 32),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_128x128.png", 128),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_256x256.png", 256),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_512x512.png", 512),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png", 1024),
        
        # Web
        ("web/favicon.png", 32),
        ("web/icons/Icon-192.png", 192),
        ("web/icons/Icon-512.png", 512),
        
        # Windows
        ("windows/runner/rechain_vc_lab_icon.png", 256),
        
        # Linux
        ("linux/icon_16x16.png", 16),
        ("linux/icon_32x32.png", 32),
        ("linux/icon_48x48.png", 48),
        ("linux/icon_64x64.png", 64),
        ("linux/icon_128x128.png", 128),
        ("linux/icon_256x256.png", 256)
    ]
    
    print("🎨 Creating icons...")
    success = 0
    
    for target_path, size in icons:
        if create_icon_from_logo(source_logo, target_path, size):
            success += 1
    
    print(f"\n📊 Created {success}/{len(icons)} icons")
    print("🚀 Run: flutter clean && flutter pub get && flutter run -d chrome")

if __name__ == "__main__":
    main()
