# Windows Project - REChain VC Lab

## 🚀 Быстрый старт

### Требования
- Visual Studio 2022 (17.0+) или Visual Studio Build Tools
- Windows 10 (19041+) или Windows 11
- Flutter 3.0+
- CMake 3.14+

### Сборка
```bash
# Debug сборка
flutter build windows --debug

# Release сборка
flutter build windows --release

# Profile сборка
flutter build windows --profile
```

## 📁 Структура проекта

```
windows/
├── CMakeLists.txt              # Основной CMake файл
├── config/                     # Конфигурационные файлы
│   ├── app_config.h           # Настройки приложения
│   ├── build_config.h         # Настройки сборки
│   └── windows_config.h       # Windows-специфичные настройки
├── flutter/                   # Flutter framework
│   ├── CMakeLists.txt
│   ├── ephemeral/
│   ├── generated_plugin_registrant.cc
│   ├── generated_plugin_registrant.h
│   └── generated_plugins.cmake
└── runner/                    # Основной код приложения
    ├── CMakeLists.txt         # CMake для runner
    ├── flutter_window.cpp     # Flutter окно
    ├── flutter_window.h       # Заголовок Flutter окна
    ├── main.cpp               # Точка входа
    ├── resource.h             # Ресурсы
    ├── resources/             # Иконки и ресурсы
    │   └── app_icon.ico       # Иконка приложения
    ├── Runner.rc              # Ресурсный файл
    ├── runner.exe.manifest    # Манифест приложения
    ├── utils.cpp              # Утилиты
    ├── utils.h                # Заголовок утилит
    ├── win32_window.cpp       # Win32 окно
    └── win32_window.h         # Заголовок Win32 окна
```

## 🔧 Конфигурации сборки

### Основные конфигурации
- **Debug** - Отладочная сборка с полной информацией
- **Release** - Оптимизированная сборка для продакшена
- **Profile** - Сборка для профилирования производительности

### Конфигурационные файлы
- `config/app_config.h` - Основные настройки приложения
- `config/build_config.h` - Настройки сборки и версии
- `config/windows_config.h` - Windows-специфичные настройки

## 🎯 Основные функции

### ✅ Настроено
- **Application ID**: `com.rechain.vc`
- **App Name**: REChain VC Lab
- **Version**: 1.0.0
- **Company**: REChain VC Lab
- **Copyright**: Copyright (C) 2025 REChain VC Lab. All rights reserved.

### 🖥️ Windows-специфичные функции
- **High DPI Support**: PerMonitorV2 DPI awareness
- **Windows 7+ Support**: Совместимость с Windows 7, 8, 8.1, 10, 11
- **Unicode Support**: Полная поддержка Unicode
- **COM Integration**: Инициализация COM для плагинов
- **Console Support**: Поддержка консоли для отладки

### 🔐 Безопасность
- **ASLR**: Address Space Layout Randomization
- **DEP**: Data Execution Prevention
- **CFG**: Control Flow Guard
- **Trust Info**: Настройки доверия в манифесте

### 🌐 Сетевые функции
- **URL Schemes**: `rechain://`, `rechainvc://`, `web3://`
- **File Associations**: `.rechain` файлы
- **Windows Sharing**: Интеграция с Windows Sharing
- **Windows Search**: Поддержка Windows Search

### 🔔 Уведомления
- **Windows Notifications**: Системные уведомления
- **Taskbar Integration**: Интеграция с панелью задач
- **Jump Lists**: Списки переходов
- **File Associations**: Ассоциации файлов

### 📁 Файловая система
- **App Data**: `%APPDATA%\REChain VC Lab`
- **Cache**: `%APPDATA%\REChain VC Lab\Cache`
- **Logs**: `%APPDATA%\REChain VC Lab\Logs`
- **Temp**: `%APPDATA%\REChain VC Lab\Temp`

## 🎨 Иконки и ресурсы

### Поддерживаемые форматы
- **ICO**: Основная иконка приложения
- **PNG**: Дополнительные изображения
- **RC**: Ресурсный файл с версией и метаданными

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

- **Windows 7** (с ограничениями)
- **Windows 8/8.1**
- **Windows 10** (19041+)
- **Windows 11**
- **x86 и x64** архитектуры

## 🔗 Интеграции

### Готовые к настройке
- **Firebase Analytics**
- **Crashlytics**
- **Google Services**
- **Windows Notifications**
- **Windows Search**

### Web3 интеграции
- **MetaMask**
- **Trust Wallet**
- **Coinbase Wallet**
- **WalletConnect**

## 📋 Следующие шаги

1. **Настройка сертификатов** для подписи
2. **Интеграция с Firebase** (опционально)
3. **Настройка Windows Store** для публикации
4. **Конфигурация Code Signing**
5. **Настройка CI/CD** (GitHub Actions)

## 🆘 Поддержка

При возникновении проблем:
1. Проверьте версию Visual Studio (2022+)
2. Убедитесь в правильности CMake (3.14+)
3. Проверьте версию Windows (10+)
4. Очистите кэш: `flutter clean && flutter pub get`

## 🔒 Безопасность

- **ASLR**: Включен для всех сборок
- **DEP**: Включен для всех сборок
- **CFG**: Включен для всех сборок
- **Trust Info**: Настроен в манифесте
- **Code Signing**: Готов к настройке

## 🚀 Производительность

- **Hardware Acceleration**: Включено
- **GPU Acceleration**: Включено
- **Multi-threading**: Включено
- **Memory Management**: Оптимизировано

---
*Последнее обновление: $(date)*
*Версия: 1.0.0*
