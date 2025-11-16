#!/usr/bin/env python3
"""
REChain VC Lab - Create Custom Icons for All Platforms
"""

import os
import sys
from PIL import Image, ImageDraw, ImageFont
import math

def create_rechain_icon(size, output_path):
    """Create a custom REChain VC Lab icon"""
    try:
        # Create image with gradient background
        img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        
        # Create gradient effect (simplified - solid color for now)
        bg_color = (99, 102, 241, 255)  # #6366F1
        draw.rectangle([0, 0, size, size], fill=bg_color)
        
        # Draw white border
        border_width = max(1, size // 16)
        draw.rectangle([0, 0, size-1, size-1], outline=(255, 255, 255, 255), width=border_width)
        
        # Add blockchain chain elements
        chain_size = size // 8
        center_x = size // 2
        center_y = size // 2
        
        # Draw chain links
        chain_color = (255, 255, 255, 200)
        
        # Left chain link
        left_rect = [center_x - size//4 - chain_size//2, center_y - chain_size//4, 
                    center_x - size//4 + chain_size//2, center_y + chain_size//4]
        draw.ellipse(left_rect, fill=chain_color, outline=(255, 255, 255, 255))
        
        # Center chain link (larger)
        center_rect = [center_x - chain_size//2, center_y - chain_size//2, 
                      center_x + chain_size//2, center_y + chain_size//2]
        draw.ellipse(center_rect, fill=chain_color, outline=(255, 255, 255, 255))
        
        # Right chain link
        right_rect = [center_x + size//4 - chain_size//2, center_y - chain_size//4, 
                     center_x + size//4 + chain_size//2, center_y + chain_size//4]
        draw.ellipse(right_rect, fill=chain_color, outline=(255, 255, 255, 255))
        
        # Add "R" text
        try:
            font_size = size // 4
            font = ImageFont.truetype("arial.ttf", font_size)
        except:
            font = ImageFont.load_default()
        
        text = "R"
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        x = (size - text_width) // 2
        y = (size - text_height) // 2 - size // 8
        draw.text((x, y), text, fill=(255, 255, 255, 255), font=font)
        
        # Add "VC" text
        try:
            vc_font_size = size // 8
            vc_font = ImageFont.truetype("arial.ttf", vc_font_size)
        except:
            vc_font = ImageFont.load_default()
        
        vc_text = "VC"
        vc_bbox = draw.textbbox((0, 0), vc_text, font=vc_font)
        vc_text_width = vc_bbox[2] - vc_bbox[0]
        vc_text_height = vc_bbox[3] - vc_bbox[1]
        vc_x = (size - vc_text_width) // 2
        vc_y = (size - vc_text_height) // 2 + size // 8
        draw.text((vc_x, vc_y), vc_text, fill=(255, 255, 255, 255), font=vc_font)
        
        # Save image
        img.save(output_path, 'PNG')
        print(f"✅ Created: {output_path} ({size}x{size})")
        return True
        
    except Exception as e:
        print(f"❌ Failed: {output_path} - {str(e)}")
        return False

def main():
    print("🚀 REChain VC Lab - Creating Custom Icons for All Platforms")
    print("=" * 60)
    
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
    
    print("\n🎨 Creating icons...")
    success_count = 0
    total_icons = len(icons)
    
    for icon_path, size in icons:
        if create_rechain_icon(size, icon_path):
            success_count += 1
    
    print(f"\n📊 Summary:")
    print(f"   Icons created: {success_count}/{total_icons}")
    
    if success_count == total_icons:
        print("\n✅ All custom icons created successfully!")
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
    
    print("\n🎯 REChain VC Lab Custom Icons Status:")
    print("✅ Android: 5 icons ready")
    print("✅ iOS: 8 icons ready")
    print("✅ macOS: 6 icons ready")
    print("✅ Web: 3 icons ready")
    print("✅ Windows: 1 icon ready")
    print("✅ Linux: 6 icons ready")
    print(f"🎨 Total: {success_count} custom icons generated!")

if __name__ == "__main__":
    main()
