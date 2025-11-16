#!/usr/bin/env python3
"""
Create basic PNG favicon for REChain VC Lab
"""

try:
    from PIL import Image, ImageDraw, ImageFont
    PIL_AVAILABLE = True
except ImportError:
    PIL_AVAILABLE = False
    print("PIL not available, creating simple placeholder")

def create_simple_favicon():
    """Create a simple favicon"""
    if PIL_AVAILABLE:
        # Create 32x32 image
        img = Image.new('RGBA', (32, 32), (99, 102, 241, 255))  # #6366F1
        draw = ImageDraw.Draw(img)
        
        # Draw border
        draw.rectangle([0, 0, 31, 31], outline=(255, 255, 255, 255), width=2)
        
        # Add "R" text
        try:
            font = ImageFont.truetype("arial.ttf", 16)
        except:
            font = None
        
        text = "R"
        if font:
            bbox = draw.textbbox((0, 0), text, font=font)
            text_width = bbox[2] - bbox[0]
            text_height = bbox[3] - bbox[1]
            x = (32 - text_width) // 2
            y = (32 - text_height) // 2
            draw.text((x, y), text, fill=(255, 255, 255, 255), font=font)
        else:
            draw.text((12, 8), text, fill=(255, 255, 255, 255))
        
        # Save favicon
        img.save('web/favicon.png', 'PNG')
        print("✅ Created web/favicon.png")
        
        # Create 192x192 icon
        img192 = Image.new('RGBA', (192, 192), (99, 102, 241, 255))
        draw192 = ImageDraw.Draw(img192)
        draw192.rectangle([0, 0, 191, 191], outline=(255, 255, 255, 255), width=4)
        
        try:
            font192 = ImageFont.truetype("arial.ttf", 96)
        except:
            font192 = None
        
        if font192:
            bbox = draw192.textbbox((0, 0), text, font=font192)
            text_width = bbox[2] - bbox[0]
            text_height = bbox[3] - bbox[1]
            x = (192 - text_width) // 2
            y = (192 - text_height) // 2
            draw192.text((x, y), text, fill=(255, 255, 255, 255), font=font192)
        else:
            draw192.text((80, 60), text, fill=(255, 255, 255, 255))
        
        img192.save('web/icons/Icon-192.png', 'PNG')
        print("✅ Created web/icons/Icon-192.png")
        
        # Create 512x512 icon
        img512 = Image.new('RGBA', (512, 512), (99, 102, 241, 255))
        draw512 = ImageDraw.Draw(img512)
        draw512.rectangle([0, 0, 511, 511], outline=(255, 255, 255, 255), width=8)
        
        try:
            font512 = ImageFont.truetype("arial.ttf", 256)
        except:
            font512 = None
        
        if font512:
            bbox = draw512.textbbox((0, 0), text, font=font512)
            text_width = bbox[2] - bbox[0]
            text_height = bbox[3] - bbox[1]
            x = (512 - text_width) // 2
            y = (512 - text_height) // 2
            draw512.text((x, y), text, fill=(255, 255, 255, 255), font=font512)
        else:
            draw512.text((200, 150), text, fill=(255, 255, 255, 255))
        
        img512.save('web/icons/Icon-512.png', 'PNG')
        print("✅ Created web/icons/Icon-512.png")
        
        return True
    else:
        print("❌ PIL not available. Please install: pip install Pillow")
        return False

if __name__ == "__main__":
    print("🎨 Creating REChain VC Lab Web Icons")
    print("=" * 40)
    
    import os
    os.makedirs('web/icons', exist_ok=True)
    
    if create_simple_favicon():
        print("\n✅ All web icons created successfully!")
        print("\n🚀 Next steps:")
        print("1. Run: flutter clean")
        print("2. Run: flutter pub get") 
        print("3. Run: flutter run -d chrome")
        print("4. Check if icons are now visible")
    else:
        print("\n❌ Failed to create icons")
