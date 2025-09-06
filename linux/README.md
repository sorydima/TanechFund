# Linux Project - REChain VC Lab

## 🚀 Быстрый старт

### Требования
- Linux (Ubuntu 18.04+, Debian 10+, Fedora 32+, Arch Linux)
- GTK 3.0+
- CMake 3.13+
- Flutter 3.0+
- GCC 7+ или Clang 6+

### Сборка
```bash
# Debug сборка
flutter build linux --debug

# Release сборка
flutter build linux --release

# Profile сборка
flutter build linux --profile
```

## 📁 Структура проекта

```
linux/
├── CMakeLists.txt              # Основной CMake файл
├── config/                     # Конфигурационные файлы
│   ├── app_config.h           # Настройки приложения
│   ├── build_config.h         # Настройки сборки
│   └── linux_config.h         # Linux-специфичные настройки
├── flutter/                   # Flutter framework
│   ├── CMakeLists.txt
│   ├── ephemeral/
│   ├── generated_plugin_registrant.cc
│   ├── generated_plugin_registrant.h
│   └── generated_plugins.cmake
├── runner/                    # Основной код приложения
│   ├── CMakeLists.txt         # CMake для runner
│   ├── main.cc                # Точка входа
│   ├── my_application.cc      # GTK приложение
│   └── my_application.h       # Заголовок GTK приложения
├── icon_*.png                 # Иконки приложения
└── com.rechain.vc.desktop     # Desktop файл
```

## 🔧 Конфигурации сборки

### Основные конфигурации
- **Debug** - Отладочная сборка с полной информацией
- **Release** - Оптимизированная сборка для продакшена
- **Profile** - Сборка для профилирования производительности

### Конфигурационные файлы
- `config/app_config.h` - Основные настройки приложения
- `config/build_config.h` - Настройки сборки и версии
- `config/linux_config.h` - Linux-специфичные настройки

## 🎯 Основные функции

### ✅ Настроено
- **Application ID**: `com.rechain.vc`
- **App Name**: REChain VC Lab
- **Version**: 1.0.0
- **Company**: REChain VC Lab
- **Copyright**: Copyright (C) 2025 REChain VC Lab. All rights reserved.

### 🐧 Linux-специфичные функции
- **GTK 3.0 Support**: Полная поддержка GTK 3.0
- **Desktop Environment Integration**: GNOME, KDE, XFCE, MATE, Cinnamon, Unity
- **Window Manager Support**: X11, Wayland
- **File System Integration**: XDG Base Directory Specification
- **Desktop File**: Правильная интеграция с Linux desktop

### 🔐 Безопасность
- **XDG Base Directory**: Соблюдение стандартов Linux
- **File Permissions**: Правильные права доступа
- **Sandboxing**: Готовность к настройке (AppArmor, SELinux)

### 🌐 Сетевые функции
- **URL Schemes**: `rechain://`, `rechainvc://`, `web3://`
- **File Associations**: `.rechain` файлы
- **Linux Sharing**: Интеграция с Linux sharing
- **Linux Search**: Поддержка Linux search

### 🔔 Уведомления
- **Linux Notifications**: Системные уведомления
- **Desktop Integration**: Интеграция с desktop environment
- **File Associations**: Ассоциации файлов
- **MIME Types**: Поддержка MIME типов

### 📁 Файловая система
- **App Data**: `~/.local/share/rechain-vc-lab`
- **Config**: `~/.config/rechain-vc-lab`
- **Cache**: `~/.cache/rechain-vc-lab`
- **Logs**: `~/.local/share/rechain-vc-lab/logs`
- **Temp**: `/tmp/rechain-vc-lab`

## 🎨 Иконки и ресурсы

### Поддерживаемые форматы
- **PNG**: Основные иконки приложения
- **Desktop**: Desktop файл для интеграции

### Размеры иконок
- 16x16, 32x32, 48x48, 64x64, 128x128, 256x256

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

- **Ubuntu** 18.04+
- **Debian** 10+
- **Fedora** 32+
- **Arch Linux**
- **openSUSE** 15+
- **x86, x64, ARM, ARM64** архитектуры

## 🔗 Интеграции

### Готовые к настройке
- **Firebase Analytics**
- **Crashlytics**
- **Google Services**
- **Linux Notifications**
- **Linux Search**

### Web3 интеграции
- **MetaMask**
- **Trust Wallet**
- **Coinbase Wallet**
- **WalletConnect**

## 📋 Следующие шаги

1. **Настройка пакетов** для распространения
2. **Интеграция с Firebase** (опционально)
3. **Настройка Linux Store** для публикации
4. **Конфигурация AppArmor/SELinux**
5. **Настройка CI/CD** (GitHub Actions)

## 🆘 Поддержка

При возникновении проблем:
1. Проверьте версию GTK (3.0+)
2. Убедитесь в правильности CMake (3.13+)
3. Проверьте версию Linux
4. Очистите кэш: `flutter clean && flutter pub get`

## 🔒 Безопасность

- **XDG Base Directory**: Соблюдение стандартов
- **File Permissions**: Правильные права доступа
- **Sandboxing**: Готовность к настройке
- **AppArmor/SELinux**: Готовность к настройке

## 🚀 Производительность

- **Hardware Acceleration**: Включено
- **GPU Acceleration**: Включено
- **Multi-threading**: Включено
- **Memory Management**: Оптимизировано

---
*Последнее обновление: $(date)*
*Версия: 1.0.0*
