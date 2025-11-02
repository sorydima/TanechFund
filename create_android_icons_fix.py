#!/usr/bin/env python3
"""
Create Android icons from existing logo
"""

import os
from PIL import Image, ImageDraw, ImageFilter
import shutil

def create_android_icons():
    """Create Android icons from existing logo"""
    
    # Source image path
    source_image = "assets/AppLogo.png"
    
    if not os.path.exists(source_image):
        print(f"Source image {source_image} not found!")
        return False
    
    # Android icon sizes
    android_sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192
    }
    
    # Create directories if they don't exist
    for folder in android_sizes.keys():
        os.makedirs(f"android/app/src/main/res/{folder}", exist_ok=True)
    
    try:
        # Load source image
        with Image.open(source_image) as img:
            # Convert to RGBA if needed
            if img.mode != 'RGBA':
                img = img.convert('RGBA')
            
            # Create a square version
            size = max(img.size)
            square_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
            
            # Paste image in center
            x = (size - img.size[0]) // 2
            y = (size - img.size[1]) // 2
            square_img.paste(img, (x, y), img)
            
            # Create icons for each density
            for folder, size in android_sizes.items():
                # Resize image
                resized = square_img.resize((size, size), Image.Resampling.LANCZOS)
                
                # Save as PNG
                output_path = f"android/app/src/main/res/{folder}/ic_launcher.png"
                resized.save(output_path, 'PNG')
                print(f"Created {output_path} ({size}x{size})")
            
            print("All Android icons created successfully!")
            return True
            
    except Exception as e:
        print(f"Error creating icons: {e}")
        return False

if __name__ == "__main__":
    create_android_icons()
