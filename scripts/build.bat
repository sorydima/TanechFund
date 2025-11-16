@echo off
echo REChain VC Group Lab - Build Script
echo ====================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Flutter is not installed or not in PATH
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo Flutter version:
flutter --version
echo.

REM Get dependencies
echo Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo Error: Failed to get dependencies
    pause
    exit /b 1
)

echo.
echo Dependencies installed successfully!
echo.

:menu
echo Choose build target:
echo 1. Android APK
echo 2. Android App Bundle
echo 3. iOS
echo 4. Web
echo 5. Windows
echo 6. macOS
echo 7. Linux
echo 8. All platforms
echo 9. Exit
echo.
set /p choice="Enter your choice (1-9): "

if "%choice%"=="1" goto android_apk
if "%choice%"=="2" goto android_bundle
if "%choice%"=="3" goto ios
if "%choice%"=="4" goto web
if "%choice%"=="5" goto windows
if "%choice%"=="6" goto macos
if "%choice%"=="7" goto linux
if "%choice%"=="8" goto all_platforms
if "%choice%"=="9" goto exit
echo Invalid choice. Please try again.
goto menu

:android_apk
echo.
echo Building Android APK...
flutter build apk --release
if %errorlevel% equ 0 (
    echo.
    echo Android APK built successfully!
    echo Location: build\app\outputs\flutter-apk\app-release.apk
) else (
    echo Error: Failed to build Android APK
)
goto end

:android_bundle
echo.
echo Building Android App Bundle...
flutter build appbundle --release
if %errorlevel% equ 0 (
    echo.
    echo Android App Bundle built successfully!
    echo Location: build\app\outputs\bundle\release\app-release.aab
) else (
    echo Error: Failed to build Android App Bundle
)
goto end

:ios
echo.
echo Building iOS...
flutter build ios --release
if %errorlevel% equ 0 (
    echo.
    echo iOS build completed successfully!
    echo Note: iOS app must be built on macOS
) else (
    echo Error: Failed to build iOS
)
goto end

:web
echo.
echo Building Web...
flutter build web --release
if %errorlevel% equ 0 (
    echo.
    echo Web build completed successfully!
    echo Location: build\web\
) else (
    echo Error: Failed to build web
)
goto end

:windows
echo.
echo Building Windows...
flutter build windows --release
if %errorlevel% equ 0 (
    echo.
    echo Windows build completed successfully!
    echo Location: build\windows\runner\Release\
) else (
    echo Error: Failed to build Windows
)
goto end

:macos
echo.
echo Building macOS...
flutter build macos --release
if %errorlevel% equ 0 (
    echo.
    echo macOS build completed successfully!
    echo Note: macOS app must be built on macOS
) else (
    echo Error: Failed to build macOS
)
goto end

:linux
echo.
echo Building Linux...
flutter build linux --release
if %errorlevel% equ 0 (
    echo.
    echo Linux build completed successfully!
    echo Location: build\linux\x64\release\bundle\
) else (
    echo Error: Failed to build Linux
)
goto end

:all_platforms
echo.
echo Building for all platforms...
echo This may take a while...
echo.

echo Building Android APK...
flutter build apk --release
echo.

echo Building Web...
flutter build web --release
echo.

echo Building Windows...
flutter build windows --release
echo.

echo Building Linux...
flutter build linux --release
echo.

echo.
echo All platform builds completed!
echo Check build folders for outputs.
goto end

:end
echo.
echo Build process completed.
echo.
pause
goto menu

:exit
echo.
echo Goodbye!
pause
exit /b 0
