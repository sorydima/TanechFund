# 🚀 Инструкции по сборке REChain VC Lab для всех платформ

Этот документ содержит подробные инструкции по сборке приложения REChain VC Lab для всех поддерживаемых платформ Flutter.

## 📋 Поддерживаемые платформы

- **Android** - мобильные приложения (.apk, .aab)
- **iOS** - мобильные приложения (.ipa)
- **Web** - веб-приложения (HTML/CSS/JS)
- **Windows** - десктопные приложения (.exe)
- **macOS** - десктопные приложения (.app, .dmg)
- **Linux** - десктопные приложения (.deb, .rpm, .AppImage)

## 🛠️ Предварительные требования

### Общие требования
- Flutter SDK 3.35.2 или выше
- Dart SDK 3.5.0 или выше
- Git

### Платформо-специфичные требования

#### Android
- Android Studio
- Android SDK (API Level 21+)
- Java Development Kit (JDK) 11+
- Gradle

#### iOS
- macOS 10.14 или выше
- Xcode 12.0 или выше
- iOS Simulator
- CocoaPods

#### Web
- Современный веб-браузер (Chrome, Edge, Firefox)
- Веб-сервер (опционально)

#### Windows
- Windows 10 или выше
- Visual Studio 2019 или выше
- CMake 3.14 или выше
- Ninja build system

#### macOS
- macOS 10.14 или выше
- Xcode 12.0 или выше
- CocoaPods

#### Linux
- Ubuntu 18.04+ или аналогичный дистрибутив
- GCC 7.0 или выше
- CMake 3.14 или выше
- pkg-config

## 🔧 Настройка окружения

### 1. Установка Flutter
```bash
# Клонирование Flutter SDK
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# Проверка установки
flutter doctor
```

### 2. Включение поддержки платформ
```bash
# Включение поддержки Windows
flutter config --enable-windows-desktop

# Включение поддержки macOS
flutter config --enable-macos-desktop

# Включение поддержки Linux
flutter config --enable-linux-desktop

# Проверка доступных платформ
flutter devices
```

### 3. Настройка проекта
```bash
# Клонирование проекта
git clone https://github.com/your-username/rechain_vc_lab.git
cd rechain_vc_lab

# Получение зависимостей
flutter pub get

# Очистка проекта
flutter clean
```

## 🚀 Сборка для разных платформ

### Быстрая сборка (Windows)
Используйте готовый скрипт:
```bash
build_all_platforms.bat
```

### Ручная сборка

#### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (для Google Play)
flutter build appbundle --release

# Результат: build/app/outputs/flutter-apk/
```

#### iOS
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release

# IPA файл
flutter build ipa --release

# Результат: build/ios/archive/
```

#### Web
```bash
# Debug build
flutter build web --debug

# Release build
flutter build web --release

# С HTML рендерером
flutter build web --web-renderer html

# С Canvas рендерером
flutter build web --web-renderer canvaskit

# Результат: build/web/
```

#### Windows
```bash
# Debug build
flutter build windows --debug

# Release build
flutter build windows --release

# Результат: build/windows/runner/Release/
```

#### macOS
```bash
# Debug build
flutter build macos --debug

# Release build
flutter build macos --release

# Результат: build/macos/Build/Products/Release/
```

#### Linux
```bash
# Debug build
flutter build linux --debug

# Release build
flutter build linux --release

# Результат: build/linux/x64/release/bundle/
```

## 📱 Сборка для всех платформ одновременно

```bash
# Очистка и получение зависимостей
flutter clean
flutter pub get

# Сборка для всех платформ
flutter build apk --release
flutter build web --release
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 🔍 Проверка результатов сборки

### Android
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **Bundle**: `build/app/outputs/bundle/release/app-release.aab`

### iOS
- **App**: `build/ios/archive/Runner.xcarchive/Products/Applications/`
- **IPA**: `build/ios/ipa/`

### Web
- **Файлы**: `build/web/`
- **Главная страница**: `build/web/index.html`

### Windows
- **EXE**: `build/windows/runner/Release/rechain_vc_lab.exe`
- **Зависимости**: `build/windows/runner/Release/`

### macOS
- **App**: `build/macos/Build/Products/Release/rechain_vc_lab.app`
- **DMG**: Создается вручную через Xcode

### Linux
- **AppImage**: `build/linux/x64/release/bundle/rechain_vc_lab`
- **Deb**: `build/linux/x64/release/bundle/`

## ⚠️ Устранение неполадок

### Общие проблемы

#### Ошибка "No supported devices connected"
```bash
# Проверка доступных устройств
flutter devices

# Запуск эмулятора Android
flutter emulators --launch <emulator_id>

# Запуск iOS симулятора
open -a Simulator
```

#### Ошибка "Failed to build"
```bash
# Очистка проекта
flutter clean

# Получение зависимостей
flutter pub get

# Проверка Flutter
flutter doctor
```

### Платформо-специфичные проблемы

#### Android
```bash
# Очистка Gradle кэша
cd android
./gradlew clean
cd ..

# Проверка Android SDK
flutter doctor --android-licenses
```

#### iOS
```bash
# Очистка CocoaPods
cd ios
pod deintegrate
pod install
cd ..

# Проверка Xcode
flutter doctor
```

#### Windows
```bash
# Проверка Visual Studio
flutter doctor

# Установка недостающих компонентов
# - C++ CMake tools for Visual Studio
# - Windows 10 SDK
```

#### Linux
```bash
# Установка зависимостей Ubuntu
sudo apt-get update
sudo apt-get install -y \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev
```

## 📊 Оптимизация сборки

### Размер приложения
```bash
# Анализ размера APK
flutter build apk --analyze-size

# Анализ размера Web
flutter build web --analyze-size
```

### Производительность
```bash
# Profile build для тестирования
flutter build apk --profile

# Release build для продакшена
flutter build apk --release
```

### Кэширование
```bash
# Включение кэширования
flutter build apk --build-cache

# Очистка кэша
flutter clean
```

## 🚀 Автоматизация

### GitHub Actions
Создайте `.github/workflows/build.yml`:
```yaml
name: Build All Platforms

on: [push, pull_request]

jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        include:
          - os: ubuntu-latest
            platform: linux
          - os: windows-latest
            platform: windows
          - os: macos-latest
            platform: macos

    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.2'
      - run: flutter pub get
      - run: flutter build ${{ matrix.platform }} --release
```

### Локальные скрипты
Используйте готовые скрипты:
- `build_all_platforms.bat` - для Windows
- `build.sh` - для Linux/macOS (создать при необходимости)

## 📚 Дополнительные ресурсы

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Build Modes](https://docs.flutter.dev/testing/build-modes)
- [Flutter Platform Support](https://docs.flutter.dev/deployment)
- [Flutter Performance](https://docs.flutter.dev/perf)

## 🤝 Поддержка

При возникновении проблем:
1. Проверьте `flutter doctor`
2. Очистите проект: `flutter clean`
3. Обновите Flutter: `flutter upgrade`
4. Создайте issue в репозитории проекта

---

**Удачной сборки! 🎉**
