@echo off
chcp 65001 >nul
title REChain VC Lab - Сборка для всех платформ

echo.
echo ========================================
echo    REChain VC Lab - Сборка для всех платформ
echo ========================================
echo.

:: Проверяем наличие Flutter
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter не найден! Установите Flutter и добавьте его в PATH
    pause
    exit /b 1
)

echo ✅ Flutter найден
echo.

:: Очищаем проект
echo 🧹 Очистка проекта...
flutter clean
if %errorlevel% neq 0 (
    echo ❌ Ошибка при очистке проекта
    pause
    exit /b 1
)

:: Получаем зависимости
echo 📦 Получение зависимостей...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Ошибка при получении зависимостей
    pause
    exit /b 1
)

echo.
echo ========================================
echo    Выберите платформу для сборки
echo ========================================
echo.
echo 1. Android APK (Debug)
echo 2. Android APK (Release)
echo 3. Android App Bundle (Release)
echo 4. Web (Release)
echo 5. Windows (Release)
echo 6. macOS (Release)
echo 7. Linux (Release)
echo 8. Все платформы
echo 9. Выход
echo.

set /p choice="Введите номер (1-9): "

if "%choice%"=="1" goto android_debug
if "%choice%"=="2" goto android_release
if "%choice%"=="3" goto android_bundle
if "%choice%"=="4" goto web_release
if "%choice%"=="5" goto windows_release
if "%choice%"=="6" goto macos_release
if "%choice%"=="7" goto linux_release
if "%choice%"=="8" goto all_platforms
if "%choice%"=="9" goto exit
goto invalid_choice

:android_debug
echo.
echo 📱 Сборка Android APK (Debug)...
flutter build apk --debug
if %errorlevel% equ 0 (
    echo ✅ Android APK (Debug) собран успешно!
    echo 📁 Файл: build\app\outputs\flutter-apk\app-debug.apk
) else (
    echo ❌ Ошибка при сборке Android APK (Debug)
)
goto end

:android_release
echo.
echo 📱 Сборка Android APK (Release)...
flutter build apk --release
if %errorlevel% equ 0 (
    echo ✅ Android APK (Release) собран успешно!
    echo 📁 Файл: build\app\outputs\flutter-apk\app-release.apk
) else (
    echo ❌ Ошибка при сборке Android APK (Release)
)
goto end

:android_bundle
echo.
echo 📱 Сборка Android App Bundle (Release)...
flutter build appbundle --release
if %errorlevel% equ 0 (
    echo ✅ Android App Bundle (Release) собран успешно!
    echo 📁 Файл: build\app\outputs\bundle\release\app-release.aab
) else (
    echo ❌ Ошибка при сборке Android App Bundle (Release)
)
goto end

:web_release
echo.
echo 🌐 Сборка Web (Release)...
flutter build web --release
if %errorlevel% equ 0 (
    echo ✅ Web (Release) собран успешно!
    echo 📁 Папка: build\web
) else (
    echo ❌ Ошибка при сборке Web (Release)
)
goto end

:windows_release
echo.
echo 🪟 Сборка Windows (Release)...
flutter build windows --release
if %errorlevel% equ 0 (
    echo ✅ Windows (Release) собран успешно!
    echo 📁 Папка: build\windows\runner\Release
) else (
    echo ❌ Ошибка при сборке Windows (Release)
)
goto end

:macos_release
echo.
echo 🍎 Сборка macOS (Release)...
flutter build macos --release
if %errorlevel% equ 0 (
    echo ✅ macOS (Release) собран успешно!
    echo 📁 Папка: build\macos\Build\Products\Release
) else (
    echo ❌ Ошибка при сборке macOS (Release)
)
goto end

:linux_release
echo.
echo 🐧 Сборка Linux (Release)...
flutter build linux --release
if %errorlevel% equ 0 (
    echo ✅ Linux (Release) собран успешно!
    echo 📁 Папка: build\linux\x64\release\bundle
) else (
    echo ❌ Ошибка при сборке Linux (Release)
)
goto end

:all_platforms
echo.
echo 🚀 Сборка для всех платформ...
echo.

echo 📱 Сборка Android...
flutter build apk --release
if %errorlevel% equ 0 (
    echo ✅ Android APK собран
) else (
    echo ❌ Ошибка Android
)

echo 🌐 Сборка Web...
flutter build web --release
if %errorlevel% equ 0 (
    echo ✅ Web собран
) else (
    echo ❌ Ошибка Web
)

echo 🪟 Сборка Windows...
flutter build windows --release
if %errorlevel% equ 0 (
    echo ✅ Windows собран
) else (
    echo ❌ Ошибка Windows
)

echo 🍎 Сборка macOS...
flutter build macos --release
if %errorlevel% equ 0 (
    echo ✅ macOS собран
) else (
    echo ❌ Ошибка macOS
)

echo 🐧 Сборка Linux...
flutter build linux --release
if %errorlevel% equ 0 (
    echo ✅ Linux собран
) else (
    echo ❌ Ошибка Linux
)

echo.
echo 🎉 Сборка для всех платформ завершена!
echo 📁 Проверьте папку build для результатов
goto end

:invalid_choice
echo.
echo ❌ Неверный выбор! Введите число от 1 до 9
goto end

:end
echo.
echo ========================================
echo    Сборка завершена
echo ========================================
echo.
echo 📁 Результаты сборки находятся в папке 'build'
echo 🔍 Используйте проводник для просмотра файлов
echo.
pause

:exit
echo.
echo 👋 До свидания!
timeout /t 2 >nul
exit
