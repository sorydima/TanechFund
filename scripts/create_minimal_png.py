#!/usr/bin/env python3
"""
Create minimal PNG files for REChain VC Lab
"""

import os
import struct
import zlib

def create_minimal_png(width, height):
    """Create a minimal valid PNG"""
    # PNG signature
    png_sig = b'\x89PNG\r\n\x1a\n'
    
    # IHDR chunk
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    ihdr_crc = zlib.crc32(b'IHDR' + ihdr_data) & 0xffffffff
    ihdr = struct.pack('>I', 13) + b'IHDR' + ihdr_data + struct.pack('>I', ihdr_crc)
    
    # Create simple image data (blue color #6366F1 = RGB(99,102,241))
    row_data = b'\x00' + b'\x63\x66\xf1' * width  # Filter + RGB
    image_data = row_data * height
    compressed = zlib.compress(image_data)
    
    # IDAT chunk
    idat_crc = zlib.crc32(b'IDAT' + compressed) & 0xffffffff
    idat = struct.pack('>I', len(compressed)) + b'IDAT' + compressed + struct.pack('>I', idat_crc)
    
    # IEND chunk
    iend_crc = zlib.crc32(b'IEND') & 0xffffffff
    iend = struct.pack('>I', 0) + b'IEND' + struct.pack('>I', iend_crc)
    
    return png_sig + ihdr + idat + iend

def create_icon(path, size):
    """Create icon file"""
    try:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        png_data = create_minimal_png(size, size)
        with open(path, 'wb') as f:
            f.write(png_data)
        print(f"✅ {path} ({size}x{size})")
        return True
    except Exception as e:
        print(f"❌ {path}: {e}")
        return False

def main():
    print("🚀 Creating REChain VC Lab Icons")
    
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
    
    success = 0
    for path, size in icons:
        if create_icon(path, size):
            success += 1
    
    print(f"\n📊 Created {success}/{len(icons)} icons")
    print("🚀 Run: flutter clean && flutter pub get && flutter run -d chrome")

if __name__ == "__main__":
    main()
