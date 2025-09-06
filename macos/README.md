# macOS Project - REChain VC Lab

## 🚀 Быстрый старт

### Требования
- Xcode 15.0+
- macOS 10.14+
- Flutter 3.0+

### Сборка
```bash
# Debug сборка
flutter build macos --debug

# Release сборка
flutter build macos --release

# Profile сборка
flutter build macos --profile
```

## 📁 Структура проекта

```
macos/
├── Runner/
│   ├── Info.plist              # Основные настройки приложения
│   ├── AppDelegate.swift       # Главный делегат приложения
│   ├── MainFlutterWindow.swift # Главное окно Flutter
│   ├── Assets.xcassets/        # Ресурсы (иконки, изображения)
│   ├── Base.lproj/            # Локализация
│   │   └── MainMenu.xib
│   ├── Configs/               # Конфигурационные файлы
│   │   ├── AppInfo.xcconfig
│   │   ├── Config.xcconfig
│   │   ├── Config-Debug.xcconfig
│   │   ├── Config-Release.xcconfig
│   │   ├── Config-Profile.xcconfig
│   │   ├── Debug.xcconfig
│   │   ├── Release.xcconfig
│   │   └── Warnings.xcconfig
│   ├── DebugProfile.entitlements # Права для debug/profile
│   └── Release.entitlements      # Права для release
├── Runner.xcodeproj/
│   ├── project.pbxproj        # Основной файл проекта
│   ├── xcshareddata/
│   │   └── xcschemes/         # Схемы сборки
│   └── project.xcworkspace/   # Настройки workspace
├── Runner.xcworkspace/        # Workspace файл
├── RunnerTests/               # Тесты
└── Flutter/                   # Flutter framework
```

## 🔧 Конфигурации сборки

### Основные схемы
- **Runner** - Универсальная схема
- **Runner-Debug** - Debug сборка
- **Runner-Release** - Release сборка
- **Runner-Profile** - Профилирование

### Конфигурационные файлы
- `Config.xcconfig` - Базовая конфигурация
- `Config-Debug.xcconfig` - Debug настройки
- `Config-Release.xcconfig` - Release настройки
- `Config-Profile.xcconfig` - Profile настройки
- `AppInfo.xcconfig` - Информация о приложении
- `Debug.xcconfig` - Debug настройки Flutter
- `Release.xcconfig` - Release настройки Flutter
- `Warnings.xcconfig` - Настройки предупреждений

## 🎯 Основные функции

### ✅ Настроено
- **Bundle ID**: `com.rechain.vc`
- **App Name**: REChain VC Lab
- **Deployment Target**: macOS 10.14+
- **Swift Version**: 5.0
- **Architecture**: arm64, x86_64

### 🔐 Права доступа
- App Sandbox (включен)
- Network (client/server)
- File Access (user-selected, downloads, pictures, music, movies)
- Hardware (camera, microphone, USB, audio-input)
- Printing
- Personal Information (addressbook, location, calendars, reminders)
- Apple Events
- CloudKit
- Push Notifications
- Game Center, In-App Purchase, Maps, HomeKit, HealthKit
- Siri, CarPlay, Wallet, Apple Pay
- Sign in with Apple
- Associated Domains

### 🌐 Сетевые функции
- App Transport Security настроен
- Cleartext traffic разрешен для разработки
- URL Schemes: `rechain://`, `rechainvc://`
- Deep Link поддержка

### 🔔 Уведомления
- Push Notifications
- UserNotifications framework
- UNUserNotificationCenterDelegate

### ☁️ CloudKit
- Контейнеры настроены
- Синхронизация данных
- iCloud интеграция

### 🍎 Apple Services
- Apple Sign In
- CloudKit
- Push Notifications
- Associated Domains

### 🖥️ macOS-специфичные функции
- **Menu Bar**: Кастомные Web3 и Blockchain Explorer пункты
- **Window Management**: Правильная активация политики
- **Document Handling**: Поддержка открытия файлов
- **File Access**: Полный доступ к пользовательским папкам
- **Hardware Access**: Камера, микрофон, USB
- **System Integration**: Apple Events, System Events
- **Accessibility**: Полная поддержка
- **High Resolution**: Поддержка Retina дисплеев
- **Dark Mode**: Полная поддержка

## 🎨 Иконки

Поддерживаются все размеры для macOS:
- 16x16 (1x, 2x)
- 32x32 (1x, 2x)
- 128x128 (1x, 2x)
- 256x256 (1x, 2x)
- 512x512 (1x, 2x)

## 🧪 Тестирование

### Доступные конфигурации
- Unit Tests
- Integration Tests
- UI Tests
- Performance Tests

## 📱 Поддерживаемые устройства

- Mac (macOS 10.14+)
- Apple Silicon (M1, M2, M3)
- Intel Macs

## 🔗 Интеграции

### Готовые к настройке
- Firebase Analytics
- Crashlytics
- Google Services
- CloudKit
- Apple Sign In
- Push Notifications

### Web3 интеграции
- MetaMask
- Trust Wallet
- Coinbase Wallet
- WalletConnect

## 📋 Следующие шаги

1. **Настройка сертификатов** для подписи
2. **Интеграция с Firebase** (опционально)
3. **Настройка Mac App Store** для публикации
4. **Конфигурация Notarization**
5. **Настройка CI/CD** (GitHub Actions)

## 🆘 Поддержка

При возникновении проблем:
1. Проверьте версию Xcode (15.0+)
2. Убедитесь в правильности Bundle ID
3. Проверьте сертификаты подписи
4. Очистите кэш: `flutter clean && flutter pub get`

## 🔒 Безопасность

- **App Sandbox**: Включен для всех конфигураций
- **Hardened Runtime**: Включен
- **Code Signing**: Настроен
- **Entitlements**: Разные для debug и release
- **CloudKit**: Контейнеры для изоляции данных

---
*Последнее обновление: $(date)*
*Версия: 1.0.0*
