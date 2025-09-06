# iOS Project - REChain VC Lab

## 🚀 Быстрый старт

### Требования
- Xcode 15.0+
- iOS 12.0+
- Flutter 3.0+

### Сборка
```bash
# Debug сборка
flutter build ios --debug

# Release сборка
flutter build ios --release

# Profile сборка
flutter build ios --profile
```

## 📁 Структура проекта

```
ios/
├── Runner/
│   ├── Info.plist              # Основные настройки приложения
│   ├── AppDelegate.swift       # Главный делегат приложения
│   ├── Assets.xcassets/        # Ресурсы (иконки, изображения)
│   ├── Base.lproj/            # Локализация
│   │   ├── LaunchScreen.storyboard
│   │   └── Main.storyboard
│   ├── *.entitlements         # Права доступа для разных конфигураций
│   ├── Config*.xcconfig       # Конфигурационные файлы сборки
│   └── GoogleService-Info.plist
├── Runner.xcodeproj/
│   ├── project.pbxproj        # Основной файл проекта
│   ├── xcshareddata/
│   │   └── xcschemes/         # Схемы сборки
│   └── project.xcworkspace/   # Настройки workspace
└── Flutter/                   # Flutter framework
```

## 🔧 Конфигурации сборки

### Основные схемы
- **Runner** - Универсальная схема
- **Runner-Debug** - Debug сборка
- **Runner-Release** - Release сборка
- **Runner-Profile** - Профилирование
- **Runner-Test** - Тестирование

### Конфигурационные файлы
- `Config.xcconfig` - Базовая конфигурация
- `Config-Debug.xcconfig` - Debug настройки
- `Config-Release.xcconfig` - Release настройки
- `Config-Profile.xcconfig` - Profile настройки
- `Config-Shared.xcconfig` - Общие настройки
- `Config-Test*.xcconfig` - Тестовые конфигурации

## 🎯 Основные функции

### ✅ Настроено
- **Bundle ID**: `com.rechain.vc`
- **App Name**: REChain VC Lab
- **Deployment Target**: iOS 12.0+
- **Swift Version**: 5.0
- **Architecture**: arm64, armv7, armv7s

### 🔐 Права доступа
- Camera (QR код сканирование)
- Photo Library (изображения профиля)
- Microphone (голосовые функции)
- Location (геолокация)
- Face ID/Touch ID (биометрия)
- Contacts (контакты)
- User Tracking (аналитика)

### 🌐 Сетевые функции
- App Transport Security настроен
- Cleartext traffic разрешен для разработки
- URL Schemes: `rechain://`, `rechainvc://`
- Deep Link поддержка

### 🔔 Уведомления
- Push Notifications
- Background Modes
- Background Processing
- Background Fetch

### ☁️ CloudKit
- Контейнеры настроены
- Синхронизация данных
- iCloud интеграция

### 🍎 Apple Services
- Apple Sign In
- Wallet интеграция
- Document Browser
- Share Extension готовность

## 🎨 Иконки

Поддерживаются все размеры для:
- iPhone (все модели)
- iPad (все модели)
- Apple Watch (все модели)
- macOS
- App Store (iOS & Watch)

## 🧪 Тестирование

### Доступные конфигурации
- Unit Tests
- Integration Tests
- UI Tests
- Performance Tests
- Stress Tests
- Smoke Tests
- Regression Tests
- Acceptance Tests
- User Acceptance Tests
- System Tests

## 📱 Поддерживаемые устройства

- iPhone (iOS 12.0+)
- iPad (iPadOS 12.0+)
- Apple Watch (watchOS 6.0+)
- macOS (macOS 10.14+)

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
3. **Настройка TestFlight** для бета-тестирования
4. **Конфигурация App Store Connect**
5. **Настройка CI/CD** (GitHub Actions)

## 🆘 Поддержка

При возникновении проблем:
1. Проверьте версию Xcode (15.0+)
2. Убедитесь в правильности Bundle ID
3. Проверьте сертификаты подписи
4. Очистите кэш: `flutter clean && flutter pub get`

---
*Последнее обновление: $(date)*
*Версия: 1.0.0*
