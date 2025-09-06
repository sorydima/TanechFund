# Web Project - REChain VC Lab

## 🚀 Быстрый старт

### Требования
- Modern Web Browser (Chrome 90+, Firefox 88+, Safari 14+, Edge 90+)
- Flutter 3.0+
- Node.js 16+ (для разработки)
- Web Server (для production)

### Сборка
```bash
# Debug сборка
flutter build web --debug

# Release сборка
flutter build web --release

# Profile сборка
flutter build web --profile
```

## 📁 Структура проекта

```
web/
├── config/                     # Конфигурационные файлы
│   ├── app_config.js          # Настройки приложения
│   ├── build_config.js        # Настройки сборки
│   └── web_config.js          # Web-специфичные настройки
├── icons/                     # Иконки приложения
│   ├── Icon-192.png          # Иконка 192x192
│   └── Icon-512.png          # Иконка 512x512
├── favicon.png                # Favicon
├── index.html                 # Основной HTML файл
├── manifest.json              # Web App Manifest
└── sw.js                      # Service Worker
```

## 🔧 Конфигурации сборки

### Основные конфигурации
- **Debug** - Отладочная сборка с полной информацией
- **Release** - Оптимизированная сборка для продакшена
- **Profile** - Сборка для профилирования производительности

### Конфигурационные файлы
- `config/app_config.js` - Основные настройки приложения
- `config/build_config.js` - Настройки сборки и версии
- `config/web_config.js` - Web-специфичные настройки

## 🎯 Основные функции

### ✅ Настроено
- **Application ID**: `com.rechain.vc`
- **App Name**: REChain VC Lab
- **Version**: 1.0.0
- **Company**: REChain VC Lab
- **Copyright**: Copyright (C) 2025 REChain VC Lab. All rights reserved.

### 🌐 Web-специфичные функции
- **PWA Support**: Progressive Web App
- **Service Worker**: Offline functionality
- **Web App Manifest**: App-like experience
- **Responsive Design**: Mobile and desktop support
- **Modern Web APIs**: Full Web API support

### 🔐 Безопасность
- **CSP**: Content Security Policy
- **HSTS**: HTTP Strict Transport Security
- **CORS**: Cross-Origin Resource Sharing
- **Sandboxing**: Ready for configuration

### 🌐 Сетевые функции
- **URL Schemes**: `rechain://`, `rechainvc://`, `web3://`
- **File Associations**: `.rechain` файлы
- **Web Sharing**: Web Share API
- **Web Search**: Web Search API

### 🔔 Уведомления
- **Web Notifications**: Browser notifications
- **Push Notifications**: Web Push API
- **Service Worker**: Background notifications
- **File Associations**: File type associations

### 📁 Файловая система
- **App Data**: Browser storage
- **Config**: Local storage
- **Cache**: Service Worker cache
- **Logs**: Console logging
- **Temp**: Temporary storage

## 🎨 Иконки и ресурсы

### Поддерживаемые форматы
- **PNG**: Основные иконки приложения
- **SVG**: Векторные иконки
- **ICO**: Favicon

### Размеры иконок
- 16x16, 32x32, 48x48, 64x64, 128x128, 192x192, 256x256, 512x512

## 🧪 Тестирование

### Доступные конфигурации
- Unit Tests
- Integration Tests
- UI Tests
- Performance Tests

### Отладка
- **Debug Logging**: Включено в debug сборке
- **Performance Monitoring**: Мониторинг производительности
- **Memory Leak Detection**: Обнаружение утечек памяти

## 📱 Поддерживаемые устройства

- **Desktop**: Windows, macOS, Linux
- **Mobile**: iOS, Android
- **Tablet**: iPad, Android tablets
- **x86, x64, ARM, ARM64** архитектуры

## 🔗 Интеграции

### Готовые к настройке
- **Firebase Analytics**
- **Crashlytics**
- **Google Services**
- **Web Notifications**
- **Web Search**

### Web3 интеграции
- **MetaMask**
- **Trust Wallet**
- **Coinbase Wallet**
- **WalletConnect**

## 📋 Следующие шаги

1. **Настройка HTTPS** для production
2. **Интеграция с Firebase** (опционально)
3. **Настройка Web Store** для публикации
4. **Конфигурация CSP**
5. **Настройка CI/CD** (GitHub Actions)

## 🆘 Поддержка

При возникновении проблем:
1. Проверьте версию браузера (современная)
2. Убедитесь в правильности Flutter (3.0+)
3. Проверьте версию Node.js (16+)
4. Очистите кэш: `flutter clean && flutter pub get`

## 🔒 Безопасность

- **CSP**: Content Security Policy
- **HSTS**: HTTP Strict Transport Security
- **CORS**: Cross-Origin Resource Sharing
- **Sandboxing**: Готовность к настройке

## 🚀 Производительность

- **Hardware Acceleration**: Включено
- **GPU Acceleration**: Включено
- **Multi-threading**: Включено
- **Memory Management**: Оптимизировано

---
*Последнее обновление: $(date)*
*Версия: 1.0.0*
