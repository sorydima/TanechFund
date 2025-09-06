# Codemagic CI/CD Build Guide - REChain VC Lab

## Обзор
Этот гайд описывает как настроить и использовать CI/CD сборку для REChain VC Lab в стиле Codemagic. Поддерживаются как Codemagic, так и GitHub Actions.

## 🚀 Быстрый старт

### Локальная сборка
```bash
# Linux/macOS
chmod +x scripts/build-codemagic.sh
./scripts/build-codemagic.sh

# Windows
scripts\build-codemagic.bat
```

### Codemagic CI/CD
1. Подключите репозиторий к Codemagic
2. Используйте конфигурацию `codemagic.yaml`
3. Настройте переменные окружения
4. Запустите сборку

### GitHub Actions
1. Файл `.github/workflows/codemagic-style.yml` уже настроен
2. Push в main ветку автоматически запустит сборку
3. Или используйте manual trigger в GitHub Actions

## 📁 Структура файлов

```
├── codemagic.yaml                    # Codemagic конфигурация
├── .github/workflows/codemagic-style.yml  # GitHub Actions
├── scripts/
│   ├── build-codemagic.sh           # Linux/macOS скрипт
│   └── build-codemagic.bat          # Windows скрипт
├── web/
│   ├── index-codemagic.html         # Стандартный index.html для CI/CD
│   └── index.html                   # Кастомный index.html (локальная сборка)
└── CODEMAGIC_BUILD_GUIDE.md         # Этот файл
```

## 🔧 Конфигурация

### Codemagic (codemagic.yaml)

**Доступные workflow:**
- `web-build` - Сборка веб-приложения
- `android-build` - Сборка Android приложения
- `ios-build` - Сборка iOS приложения
- `multi-platform-build` - Сборка всех платформ

**Переменные окружения:**
```yaml
vars:
  FLUTTER_BUILD_MODE: "release"
  FLUTTER_WEB_RENDERER: "auto"
  DEPLOY_BUCKET: "your-s3-bucket"
  DEPLOY_REGION: "us-east-1"
  CUSTOM_DOMAIN: "vc.rechain.network"
```

### GitHub Actions (.github/workflows/codemagic-style.yml)

**Триггеры:**
- Push в main/develop ветки
- Pull requests в main
- Manual workflow dispatch

**Параметры manual trigger:**
- `build_mode`: debug/release
- `platforms`: web/android/ios/all

## 🛠️ Локальная сборка

### Linux/macOS
```bash
# Сделать скрипт исполняемым
chmod +x scripts/build-codemagic.sh

# Запустить сборку
./scripts/build-codemagic.sh
```

**Что делает скрипт:**
1. ✅ Проверяет Flutter установку
2. ✅ Запускает `flutter doctor`
3. ✅ Настраивает `local.properties`
4. ✅ Получает зависимости
5. ✅ Запускает анализ и тесты
6. ✅ Собирает веб-приложение
7. ✅ Собирает Android (если доступно)
8. ✅ Собирает iOS (если на macOS)
9. ✅ Собирает macOS (если на macOS)
10. ✅ Собирает Windows (если на Windows)
11. ✅ Собирает Linux (если на Linux)
12. ✅ Создает архивы

### Windows
```cmd
REM Запустить сборку
scripts\build-codemagic.bat
```

**Что делает скрипт:**
1. ✅ Проверяет Flutter установку
2. ✅ Запускает `flutter doctor`
3. ✅ Настраивает `local.properties`
4. ✅ Получает зависимости
5. ✅ Запускает анализ и тесты
6. ✅ Собирает веб-приложение
7. ✅ Собирает Android (если доступно)
8. ✅ Собирает Windows
9. ✅ Создает ZIP архивы

## 🌐 Веб-сборка

### Стандартная конфигурация
Для CI/CD используется `web/index-codemagic.html`:
- Стандартная конфигурация Flutter Web
- Автоматический выбор renderer
- Поддержка CanvasKit и HTML renderer
- Оптимизированная загрузка

### Команда сборки
```bash
flutter build web \
  --release \
  --no-tree-shake-icons \
  --dart-define=FLUTTER_WEB_RENDERER=auto \
  --base-href="/" \
  --web-renderer=auto
```

### Результат сборки
```
build/web/
├── index.html              # Основной файл
├── main.dart.js           # Скомпилированный код
├── flutter.js             # Flutter engine
├── flutter_bootstrap.js   # Bootstrap loader
├── assets/                # Ресурсы
├── icons/                 # Иконки
├── manifest.json          # PWA манифест
└── build-info.txt         # Информация о сборке
```

## 📱 Android сборка

### Требования
- Java 17+
- Android SDK
- Flutter с Android поддержкой

### Команды сборки
```bash
# App Bundle (для Google Play)
flutter build appbundle --release

# APK (для тестирования)
flutter build apk --release
```

### Результат
```
build/app/outputs/
├── bundle/release/
│   └── app-release.aab    # App Bundle
└── flutter-apk/
    └── app-release.apk    # APK файл
```

## 🍎 iOS сборка

### Требования
- macOS
- Xcode
- Flutter с iOS поддержкой

### Команда сборки
```bash
flutter build ios --release --no-codesign
```

### Результат
```
build/ios/
├── Runner.app/            # iOS приложение
└── ipa/                   # IPA файлы (если созданы)
```

## 🖥️ Desktop сборка

### macOS
```bash
flutter build macos --release
```

### Windows
```bash
flutter build windows --release
```

### Linux
```bash
flutter build linux --release
```

## 🚀 Развертывание

### Веб-приложение
1. **Загрузите папку `build/web/`** на хостинг
2. **Убедитесь что `.htaccess` загружен** (если есть)
3. **Проверьте права доступа** к файлам
4. **Настройте домен** (если нужно)

### Android
1. **Загрузите AAB** в Google Play Console
2. **Заполните метаданные**
3. **Запустите тестирование**
4. **Опубликуйте в продакшн**

### iOS
1. **Загрузите IPA** в App Store Connect
2. **Заполните метаданные**
3. **Запустите тестирование**
4. **Опубликуйте в App Store**

## 🔍 Мониторинг и отладка

### Логи сборки
Все скрипты выводят подробные логи:
- ✅ Успешные шаги (зеленый)
- ⚠️ Предупреждения (желтый)
- ❌ Ошибки (красный)

### Build Info
Каждая сборка создает `build-info.txt`:
```
Build Date: 2024-01-15 10:30:00
Build ID: 20240115_103000
Flutter Version: 3.24.0
Build Mode: release
Web Renderer: auto
Platform: Linux
Architecture: x86_64
```

### Размеры сборки
Скрипты показывают размеры:
```
Web build size: 15.2M
Android AAB size: 25.8M
Android APK size: 28.1M
```

## 🛡️ Безопасность

### Переменные окружения
Никогда не коммитьте:
- API ключи
- Пароли
- Сертификаты
- Приватные ключи

### Codemagic Secrets
Настройте в Codemagic:
- `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`
- `APP_STORE_CONNECT_API_KEY`
- `GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS`

### GitHub Secrets
Настройте в GitHub:
- `GITHUB_TOKEN`
- `DEPLOY_TOKEN`
- `API_KEYS`

## 📊 Оптимизация

### Веб-сборка
- ✅ `--no-tree-shake-icons` - сохраняет все иконки
- ✅ `--web-renderer=auto` - автоматический выбор renderer
- ✅ `--base-href="/"` - правильные пути

### Android сборка
- ✅ `--release` - оптимизированная сборка
- ✅ App Bundle - меньший размер
- ✅ ProGuard/R8 - обфускация кода

### iOS сборка
- ✅ `--release` - оптимизированная сборка
- ✅ `--no-codesign` - для CI/CD
- ✅ Archive - для App Store

## 🆘 Решение проблем

### Flutter не найден
```bash
# Проверить PATH
echo $PATH

# Добавить Flutter в PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Android SDK не найден
```bash
# Установить Android SDK
flutter doctor --android-licenses

# Настроить ANDROID_HOME
export ANDROID_HOME="/path/to/android/sdk"
```

### iOS сборка не работает
```bash
# Установить Xcode
xcode-select --install

# Настроить iOS симулятор
flutter emulators --launch apple_ios_simulator
```

### Веб-сборка не работает
```bash
# Очистить кэш
flutter clean

# Переустановить зависимости
flutter packages pub get

# Пересобрать
flutter build web --release
```

## 📚 Дополнительные ресурсы

### Документация
- [Flutter Web](https://docs.flutter.dev/platform-integration/web)
- [Codemagic](https://docs.codemagic.io/)
- [GitHub Actions](https://docs.github.com/en/actions)

### Полезные команды
```bash
# Проверить Flutter
flutter doctor -v

# Очистить проект
flutter clean

# Обновить зависимости
flutter packages pub upgrade

# Анализ кода
flutter analyze

# Запуск тестов
flutter test

# Проверить размер сборки
du -sh build/web/
```

## 🎯 Заключение

Этот гайд предоставляет полное решение для CI/CD сборки REChain VC Lab:

**✅ Поддерживаемые платформы:**
- Web (HTML/CanvasKit renderer)
- Android (AAB/APK)
- iOS (IPA)
- macOS (App)
- Windows (Executable)
- Linux (AppImage)

**✅ CI/CD системы:**
- Codemagic
- GitHub Actions
- Локальные скрипты

**✅ Автоматизация:**
- Анализ кода
- Тестирование
- Сборка
- Создание архивов
- Развертывание

**✅ Мониторинг:**
- Подробные логи
- Информация о сборке
- Размеры файлов
- Статистика

Используйте этот гайд для настройки профессионального CI/CD pipeline для вашего Flutter приложения! 🚀

---
*Создано: $(date)*
*Версия: 1.0.0*
*Приложение: REChain VC Lab*
*Тип: CI/CD Build Guide*
