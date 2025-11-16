#!/usr/bin/env python3
"""
Скрипт для создания иконок Android из AppLogo.jpg
"""

import os
import shutil
from PIL import Image

def create_android_icons():
    # Размеры иконок для разных плотностей экрана
    icon_sizes = {
        'mipmap-mdpi': 48,    # 1x
        'mipmap-hdpi': 72,    # 1.5x
        'mipmap-xhdpi': 96,   # 2x
        'mipmap-xxhdpi': 144, # 3x
        'mipmap-xxxhdpi': 192 # 4x
    }
    
    source_image = 'assets/AppLogo.jpg'
    
    if not os.path.exists(source_image):
        print(f"Ошибка: файл {source_image} не найден!")
        return False
    
    try:
        # Открываем исходное изображение
        with Image.open(source_image) as img:
            # Конвертируем в RGBA если нужно
            if img.mode != 'RGBA':
                img = img.convert('RGBA')
            
            # Создаем иконки для каждой плотности
            for folder, size in icon_sizes.items():
                folder_path = f'android/app/src/main/res/{folder}'
                
                # Создаем папку если не существует
                os.makedirs(folder_path, exist_ok=True)
                
                # Изменяем размер изображения
                resized_img = img.resize((size, size), Image.Resampling.LANCZOS)
                
                # Сохраняем как PNG
                output_path = f'{folder_path}/ic_launcher.png'
                resized_img.save(output_path, 'PNG')
                print(f"Создана иконка: {output_path} ({size}x{size})")
        
        print("Все иконки Android созданы успешно!")
        return True
        
    except Exception as e:
        print(f"Ошибка при создании иконок: {e}")
        return False

if __name__ == "__main__":
    create_android_icons()

