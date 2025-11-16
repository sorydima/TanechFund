#!/usr/bin/env python3
"""
Скрипт для генерации кастомных иконок для всех платформ Flutter приложения REChain VC Lab
"""

import os
import subprocess
import sys
from pathlib import Path

def install_requirements():
    """Установка необходимых зависимостей"""
    try:
        import cairosvg
        import PIL
        print("✅ Все зависимости уже установлены")
    except ImportError:
        print("📦 Установка зависимостей...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "cairosvg", "Pillow"])
        print("✅ Зависимости установлены")

def generate_png_from_svg(svg_path, output_path, size):
    """Генерация PNG из SVG с заданным размером"""
    try:
        import cairosvg
        from PIL import Image
        import io
        
        # Конвертируем SVG в PNG
        png_data = cairosvg.svg2png(url=svg_path, output_width=size, output_height=size)
        
        # Открываем как PIL Image для дополнительной обработки
        img = Image.open(io.BytesIO(png_data))
        
        # Создаем папку если не существует
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        # Сохраняем PNG
        img.save(output_path, "PNG")
        print(f"✅ Создана иконка: {output_path} ({size}x{size})")
        
    except Exception as e:
        print(f"❌ Ошибка при создании {output_path}: {e}")

def generate_ico_from_png(png_path, ico_path):
    """Генерация ICO файла из PNG"""
    try:
        from PIL import Image
        
        # Открываем PNG
        img = Image.open(png_path)
        
        # Создаем папку если не существует
        os.makedirs(os.path.dirname(ico_path), exist_ok=True)
        
        # Сохраняем как ICO
        img.save(ico_path, "ICO", sizes=[(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
        print(f"✅ Создан ICO файл: {ico_path}")
        
    except Exception as e:
        print(f"❌ Ошибка при создании {ico_path}: {e}")

def main():
    """Основная функция"""
    print("🚀 Генерация кастомных иконок для REChain VC Lab")
    print("=" * 50)
    
    # Установка зависимостей
    install_requirements()
    
    # Путь к SVG иконке
    svg_path = "assets/icons/rechain_vc_lab_icon.svg"
    
    if not os.path.exists(svg_path):
        print(f"❌ SVG файл не найден: {svg_path}")
        return
    
    print(f"📁 Исходный SVG файл: {svg_path}")
    
    # Android иконки
    print("\n📱 Генерация Android иконок...")
    android_sizes = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192
    }
    
    for folder, size in android_sizes.items():
        output_path = f"android/app/src/main/res/{folder}/ic_launcher.png"
        generate_png_from_svg(svg_path, output_path, size)
    
    # iOS иконки
    print("\n🍎 Генерация iOS иконок...")
    ios_sizes = {
        "AppIcon.appiconset/icon-20.png": 20,
        "AppIcon.appiconset/icon-29.png": 29,
        "AppIcon.appiconset/icon-40.png": 40,
        "AppIcon.appiconset/icon-50.png": 50,
        "AppIcon.appiconset/icon-57.png": 57,
        "AppIcon.appiconset/icon-60.png": 60,
        "AppIcon.appiconset/icon-72.png": 72,
        "AppIcon.appiconset/icon-76.png": 76,
        "AppIcon.appiconset/icon-80.png": 80,
        "AppIcon.appiconset/icon-87.png": 87,
        "AppIcon.appiconset/icon-100.png": 100,
        "AppIcon.appiconset/icon-114.png": 114,
        "AppIcon.appiconset/icon-120.png": 120,
        "AppIcon.appiconset/icon-144.png": 144,
        "AppIcon.appiconset/icon-152.png": 152,
        "AppIcon.appiconset/icon-167.png": 167,
        "AppIcon.appiconset/icon-180.png": 180,
        "AppIcon.appiconset/icon-1024.png": 1024
    }
    
    for filename, size in ios_sizes.items():
        output_path = f"ios/Runner/Assets.xcassets/{filename}"
        generate_png_from_svg(svg_path, output_path, size)
    
    # Web иконки
    print("\n🌐 Генерация Web иконок...")
    web_sizes = {
        "web/icons/Icon-192.png": 192,
        "web/icons/Icon-512.png": 512,
        "web/icons/Icon-maskable-192.png": 192,
        "web/icons/Icon-maskable-512.png": 512,
        "web/favicon.png": 32
    }
    
    for filename, size in web_sizes.items():
        generate_png_from_svg(svg_path, filename, size)
    
    # Windows иконки
    print("\n🪟 Генерация Windows иконок...")
    windows_png = "windows/runner/rechain_vc_lab_icon.png"
    windows_ico = "windows/runner/rechain_vc_lab_icon.ico"
    
    generate_png_from_svg(svg_path, windows_png, 256)
    generate_ico_from_png(windows_png, windows_ico)
    
    # macOS иконки
    print("\n💻 Генерация macOS иконок...")
    macos_sizes = {
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_16x16.png": 16,
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_32x32.png": 32,
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_64x64.png": 64,
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_128x128.png": 128,
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_256x256.png": 256,
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_512x512.png": 512,
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png": 1024
    }
    
    for filename, size in macos_sizes.items():
        generate_png_from_svg(svg_path, filename, size)
    
    # Linux иконки
    print("\n🐧 Генерация Linux иконок...")
    linux_sizes = {
        "linux/icon_16x16.png": 16,
        "linux/icon_32x32.png": 32,
        "linux/icon_48x48.png": 48,
        "linux/icon_64x64.png": 64,
        "linux/icon_128x128.png": 128,
        "linux/icon_256x256.png": 256
    }
    
    for filename, size in linux_sizes.items():
        generate_png_from_svg(svg_path, filename, size)
    
    print("\n🎉 Все иконки успешно сгенерированы!")
    print("=" * 50)
    print("📋 Следующие шаги:")
    print("1. Удалите старые стандартные иконки")
    print("2. Обновите конфигурационные файлы")
    print("3. Пересоберите приложение")

if __name__ == "__main__":
    main()
