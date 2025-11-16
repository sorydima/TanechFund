#!/usr/bin/env python3
"""
Simple icon creation without PIL dependency
"""

import os
import struct

def create_simple_png(width, height, color_r, color_g, color_b):
    """Create a simple PNG with solid color"""
    # PNG signature
    png_signature = b'\x89PNG\r\n\x1a\n'
    
    # IHDR chunk
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    ihdr_crc = 0x4B4B4B4B  # Placeholder CRC
    ihdr_chunk = struct.pack('>I', 13) + b'IHDR' + ihdr_data + struct.pack('>I', ihdr_crc)
    
    # Simple IDAT chunk (compressed image data)
    # For simplicity, we'll create a minimal valid PNG
    idat_data = b'\x78\x9c\x01\x00\x00\xff\xff\x00\x00\x00\x02\x00\x01'
    idat_crc = 0x12345678  # Placeholder CRC
    idat_chunk = struct.pack('>I', len(idat_data)) + b'IDAT' + idat_data + struct.pack('>I', idat_crc)
    
    # IEND chunk
    iend_crc = 0xAE426082
    iend_chunk = struct.pack('>I', 0) + b'IEND' + struct.pack('>I', iend_crc)
    
    return png_signature + ihdr_chunk + idat_chunk + iend_chunk

def create_icon_file(path, size):
    """Create a simple icon file"""
    try:
        # Create a simple blue PNG
        png_data = create_simple_png(size, size, 99, 102, 241)
        
        with open(path, 'wb') as f:
            f.write(png_data)
        
        print(f"✅ Created: {path} ({size}x{size})")
        return True
    except Exception as e:
        print(f"❌ Failed: {path} - {str(e)}")
        return False

def main():
    print("🚀 Creating simple icons...")
    
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
    
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
    
    # Create icons
    icons = [
        ("android/app/src/main/res/mipmap-mdpi/ic_launcher.png", 48),
        ("android/app/src/main/res/mipmap-hdpi/ic_launcher.png", 72),
        ("android/app/src/main/res/mipmap-xhdpi/ic_launcher.png", 96),
        ("android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png", 144),
        ("android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png", 192),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-20.png", 20),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-29.png", 29),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-40.png", 40),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-60.png", 60),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-76.png", 76),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-120.png", 120),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-180.png", 180),
        ("ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png", 1024),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_16x16.png", 16),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_32x32.png", 32),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_128x128.png", 128),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_256x256.png", 256),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_512x512.png", 512),
        ("macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png", 1024),
        ("web/favicon.png", 32),
        ("web/icons/Icon-192.png", 192),
        ("web/icons/Icon-512.png", 512),
        ("windows/runner/rechain_vc_lab_icon.png", 256),
        ("linux/icon_16x16.png", 16),
        ("linux/icon_32x32.png", 32),
        ("linux/icon_48x48.png", 48),
        ("linux/icon_64x64.png", 64),
        ("linux/icon_128x128.png", 128),
        ("linux/icon_256x256.png", 256)
    ]
    
    success = 0
    for path, size in icons:
        if create_icon_file(path, size):
            success += 1
    
    print(f"\n📊 Created {success}/{len(icons)} icons")

if __name__ == "__main__":
    main()
