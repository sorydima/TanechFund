#!/usr/bin/env python3
"""
Создание простой иконки для Android
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_simple_icon(size, output_path):
    # Создаем изображение с прозрачным фоном
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Рисуем простой круг с текстом
    margin = size // 8
    draw.ellipse([margin, margin, size-margin, size-margin], 
                 fill=(33, 150, 243, 255), outline=(25, 118, 210, 255), width=2)
    
    # Добавляем текст "RC"
    try:
        font_size = size // 3
        font = ImageFont.truetype("arial.ttf", font_size)
    except:
        font = ImageFont.load_default()
    
    text = "RC"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (size - text_width) // 2
    y = (size - text_height) // 2
    
    draw.text((x, y), text, fill=(255, 255, 255, 255), font=font)
    
    # Сохраняем изображение
    img.save(output_path, 'PNG')
    print(f"Создана иконка: {output_path} ({size}x{size})")

def main():
    # Размеры иконок для разных плотностей экрана
    icon_sizes = {
        'mipmap-mdpi': 48,    # 1x
        'mipmap-hdpi': 72,    # 1.5x
        'mipmap-xhdpi': 96,   # 2x
        'mipmap-xxhdpi': 144, # 3x
        'mipmap-xxxhdpi': 192 # 4x
    }
    
    for folder, size in icon_sizes.items():
        folder_path = f'android/app/src/main/res/{folder}'
        os.makedirs(folder_path, exist_ok=True)
        output_path = f'{folder_path}/ic_launcher.png'
        create_simple_icon(size, output_path)
    
    print("Все иконки созданы успешно!")

if __name__ == "__main__":
    main()