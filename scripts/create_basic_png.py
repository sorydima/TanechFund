#!/usr/bin/env python3
"""
Create basic PNG files for REChain VC Lab icons
"""

import os
import struct
import zlib

def create_basic_png(width, height, r=99, g=102, b=241):
    """Create a basic PNG with solid color"""
    
    # PNG signature
    png_signature = b'\x89PNG\r\n\x1a\n'
    
    # Create image data (RGB)
    row_bytes = width * 3
    image_data = b''
    for y in range(height):
        # Filter type (0 = None)
        image_data += b'\x00'
        # RGB data for one row
        for x in range(width):
            image_data += bytes([r, g, b])
    
    # Compress image data
    compressed_data = zlib.compress(image_data)
    
    # IHDR chunk
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    ihdr_crc = zlib.crc32(b'IHDR' + ihdr_data) & 0xffffffff
    ihdr_chunk = struct.pack('>I', 13) + b'IHDR' + ihdr_data + struct.pack('>I', ihdr_crc)
    
    # IDAT chunk
    idat_crc = zlib.crc32(b'IDAT' + compressed_data) & 0xffffffff
    idat_chunk = struct.pack('>I', len(compressed_data)) + b'IDAT' + compressed_data + struct.pack('>I', idat_crc)
    
    # IEND chunk
    iend_crc = zlib.crc32(b'IEND') & 0xffffffff
    iend_chunk = struct.pack('>I', 0) + b'IEND' + struct.pack('>I', iend_crc)
    
    return png_signature + ihdr_chunk + idat_chunk + iend_chunk

def create_icon(path, size):
    """Create an icon file"""
    try:
        png_data = create_basic_png(size, size)
        
        # Ensure directory exists
        os.makedirs(os.path.dirname(path), exist_ok=True)
        
        with open(path, 'wb') as f:
            f.write(png_data)
        
        print(f"✅ Created: {path} ({size}x{size})")
        return True
    except Exception as e:
        print(f"❌ Failed: {path} - {str(e)}")
        return False

def main():
    print("🚀 REChain VC Lab - Creating Basic PNG Icons")
    print("=" * 50)
    
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
    
    for path, size in icons:
        if create_icon(path, size):
            success += 1
    
    print(f"\n📊 Summary:")
    print(f"   Icons created: {success}/{len(icons)}")
    
    if success == len(icons):
        print("\n✅ All icons created successfully!")
        print("\n🚀 Next Steps:")
        print("1. Run 'flutter clean'")
        print("2. Run 'flutter pub get'")
        print("3. Test: flutter run -d chrome")
    else:
        print(f"\n⚠️ {len(icons) - success} icons failed to create.")
    
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
