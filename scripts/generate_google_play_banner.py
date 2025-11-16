#!/usr/bin/env python3
"""
REChain VC Lab - Google Play Store Banner Generator
Creates a 1024x500 PNG banner for Google Play Store
"""

from PIL import Image, ImageDraw, ImageFont
import os
import sys

def create_google_play_banner():
    """Create Google Play Store banner for REChain VC Lab"""
    
    # Banner dimensions (Google Play Store requirements)
    width = 1024
    height = 500
    
    # Create image with gradient background
    image = Image.new('RGB', (width, height), color='white')
    draw = ImageDraw.Draw(image)
    
    # Create gradient background
    for y in range(height):
        # Create gradient from #667eea to #764ba2
        ratio = y / height
        r = int(102 + (118 - 102) * ratio)  # 102 to 118
        g = int(126 + (75 - 126) * ratio)   # 126 to 75
        b = int(234 + (162 - 234) * ratio)  # 234 to 162
        
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    # Add background pattern
    add_background_pattern(draw, width, height)
    
    # Add app icon
    add_app_icon(draw, width, height)
    
    # Add text content
    add_text_content(draw, width, height)
    
    # Add download button
    add_download_button(draw, width, height)
    
    return image

def add_background_pattern(draw, width, height):
    """Add subtle background pattern"""
    # Add some subtle circles for depth
    for i in range(3):
        x = width * (0.2 + i * 0.3)
        y = height * (0.2 + i * 0.2)
        radius = 100 + i * 50
        
        # Semi-transparent white circles
        for r in range(radius, 0, -10):
            alpha = int(20 * (1 - r / radius))
            if alpha > 0:
                draw.ellipse([x-r, y-r, x+r, y+r], 
                           fill=(255, 255, 255, alpha), 
                           outline=None)

def add_app_icon(draw, width, height):
    """Add app icon on the right side"""
    # Icon position and size
    icon_size = 180
    icon_x = width - 60 - icon_size
    icon_y = (height - icon_size) // 2
    
    # Icon background (white rounded rectangle)
    draw.rounded_rectangle([icon_x, icon_y, icon_x + icon_size, icon_y + icon_size], 
                          radius=25, fill='white', outline=None)
    
    # Add shadow effect
    shadow_offset = 5
    draw.rounded_rectangle([icon_x + shadow_offset, icon_y + shadow_offset, 
                           icon_x + icon_size + shadow_offset, icon_y + icon_size + shadow_offset], 
                          radius=25, fill=(0, 0, 0, 30), outline=None)
    
    # Icon content - "R" letter
    try:
        # Try to use a system font
        font_size = 120
        font = ImageFont.truetype("arial.ttf", font_size)
    except:
        try:
            font = ImageFont.truetype("Arial.ttf", font_size)
        except:
            # Fallback to default font
            font = ImageFont.load_default()
    
    # Calculate text position
    text = "R"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    text_x = icon_x + (icon_size - text_width) // 2
    text_y = icon_y + (icon_size - text_height) // 2
    
    # Draw "R" with gradient effect (simulated with multiple colors)
    colors = [(102, 126, 234), (118, 75, 162)]
    for i, color in enumerate(colors):
        offset = i * 2
        draw.text((text_x + offset, text_y + offset), text, 
                 font=font, fill=color)

def add_text_content(draw, width, height):
    """Add main text content"""
    # App title
    title = "REChain VC Lab"
    title_font_size = 72
    
    try:
        title_font = ImageFont.truetype("arial.ttf", title_font_size)
    except:
        try:
            title_font = ImageFont.truetype("Arial.ttf", title_font_size)
        except:
            title_font = ImageFont.load_default()
    
    title_x = 60
    title_y = 80
    
    # Draw title with shadow
    draw.text((title_x + 3, title_y + 3), title, font=title_font, fill=(0, 0, 0, 100))
    draw.text((title_x, title_y), title, font=title_font, fill='white')
    
    # App subtitle
    subtitle = "Web3 Venture Capital Laboratory"
    subtitle_font_size = 36
    
    try:
        subtitle_font = ImageFont.truetype("arial.ttf", subtitle_font_size)
    except:
        try:
            subtitle_font = ImageFont.truetype("Arial.ttf", subtitle_font_size)
        except:
            subtitle_font = ImageFont.load_default()
    
    subtitle_x = 60
    subtitle_y = title_y + 90
    
    # Draw subtitle with shadow
    draw.text((subtitle_x + 2, subtitle_y + 2), subtitle, font=subtitle_font, fill=(0, 0, 0, 80))
    draw.text((subtitle_x, subtitle_y), subtitle, font=subtitle_font, fill='white')
    
    # App description
    description = "Advanced tools for blockchain investment analysis,\nportfolio management, and Web3 ecosystem exploration"
    desc_font_size = 24
    
    try:
        desc_font = ImageFont.truetype("arial.ttf", desc_font_size)
    except:
        try:
            desc_font = ImageFont.truetype("Arial.ttf", desc_font_size)
        except:
            desc_font = ImageFont.load_default()
    
    desc_x = 60
    desc_y = subtitle_y + 70
    
    # Draw description with shadow
    draw.text((desc_x + 1, desc_y + 1), description, font=desc_font, fill=(0, 0, 0, 60))
    draw.text((desc_x, desc_y), description, font=desc_font, fill='white')

def add_download_button(draw, width, height):
    """Add download button"""
    button_width = 200
    button_height = 50
    button_x = width - 60 - button_width
    button_y = height - 60 - button_height
    
    # Button background with transparency effect
    draw.rounded_rectangle([button_x, button_y, button_x + button_width, button_y + button_height], 
                          radius=25, fill=(255, 255, 255, 50), outline=(255, 255, 255, 100))
    
    # Button text
    button_text = "Download Now"
    button_font_size = 18
    
    try:
        button_font = ImageFont.truetype("arial.ttf", button_font_size)
    except:
        try:
            button_font = ImageFont.truetype("Arial.ttf", button_font_size)
        except:
            button_font = ImageFont.load_default()
    
    # Calculate text position
    bbox = draw.textbbox((0, 0), button_text, font=button_font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    text_x = button_x + (button_width - text_width) // 2
    text_y = button_y + (button_height - text_height) // 2
    
    # Draw button text
    draw.text((text_x, text_y), button_text, font=button_font, fill='white')

def main():
    """Main function to generate and save the banner"""
    print("🎨 Generating REChain VC Lab Google Play Store Banner...")
    
    try:
        # Create the banner
        banner = create_google_play_banner()
        
        # Save the banner
        output_filename = "rechain_vc_lab_google_play_banner_1024x500.png"
        banner.save(output_filename, "PNG", optimize=True)
        
        # Get file size
        file_size = os.path.getsize(output_filename)
        file_size_kb = file_size / 1024
        
        print(f"✅ Banner generated successfully!")
        print(f"📁 File: {output_filename}")
        print(f"📏 Dimensions: 1024 x 500 pixels")
        print(f"💾 File size: {file_size_kb:.1f} KB")
        print(f"🎯 Format: PNG")
        
        if file_size_kb > 1024:
            print("⚠️  Warning: File size exceeds 1MB limit for Google Play Store")
            print("💡 Consider optimizing the image or reducing quality")
        else:
            print("✅ File size is within Google Play Store limits (< 1MB)")
            
    except Exception as e:
        print(f"❌ Error generating banner: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
