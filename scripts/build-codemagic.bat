@echo off
REM REChain VC Lab - Codemagic-style Build Script for Windows
REM This script mimics the Codemagic CI/CD build process locally

setlocal enabledelayedexpansion

REM Build configuration
set FLUTTER_BUILD_MODE=release
set FLUTTER_WEB_RENDERER=auto
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set BUILD_ID=%dt:~0,8%_%dt:~8,6%

echo 🚀 REChain VC Lab - Codemagic-style Build
echo Build ID: %BUILD_ID%
echo Build Mode: %FLUTTER_BUILD_MODE%
echo Web Renderer: %FLUTTER_WEB_RENDERER%
echo.

REM Check if Flutter is installed
echo 📋 Checking Flutter installation...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter is not installed or not in PATH
    exit /b 1
)
flutter --version
echo ✅ Flutter is available
echo.

REM Check Flutter doctor
echo 📋 Running Flutter doctor...
flutter doctor
echo ✅ Flutter doctor completed
echo.

REM Set up local.properties for Android
echo 📋 Setting up local.properties...
if exist "android" (
    echo flutter.sdk=%FLUTTER_ROOT% > android\local.properties
    echo ✅ local.properties created
) else (
    echo No android directory found, skipping local.properties
)
echo.

REM Get Flutter packages
echo 📋 Getting Flutter packages...
flutter packages pub get
if errorlevel 1 (
    echo ❌ Failed to get Flutter packages
    exit /b 1
)
echo ✅ Flutter packages retrieved
echo.

REM Run Flutter analyze
echo 📋 Running Flutter analyze...
flutter analyze
if errorlevel 1 (
    echo ❌ Flutter analyze failed
    exit /b 1
)
echo ✅ Flutter analyze completed
echo.

REM Run Flutter tests
echo 📋 Running Flutter tests...
flutter test
if errorlevel 1 (
    echo ❌ Flutter tests failed
    exit /b 1
)
echo ✅ Flutter tests completed
echo.

REM Build Web App
echo 📋 Building Flutter web app...
if exist "web\index-codemagic.html" (
    copy "web\index-codemagic.html" "web\index.html" >nul
    echo Using Codemagic-style index.html
)

flutter build web --release --no-tree-shake-icons --dart-define=FLUTTER_WEB_RENDERER=%FLUTTER_WEB_RENDERER% --base-href="/" --web-renderer=auto
if errorlevel 1 (
    echo ❌ Web build failed
    exit /b 1
)
echo ✅ Web app built successfully
echo.

REM Build Android App Bundle (if Android is available)
if exist "android" (
    echo 📋 Building Android App Bundle...
    flutter build appbundle --release
    if errorlevel 1 (
        echo ❌ Android App Bundle build failed
    ) else (
        echo ✅ Android App Bundle built successfully
    )
    echo.
    
    echo 📋 Building Android APK...
    flutter build apk --release
    if errorlevel 1 (
        echo ❌ Android APK build failed
    ) else (
        echo ✅ Android APK built successfully
    )
    echo.
) else (
    echo Skipping Android build (Android directory not available)
    echo.
)

REM Build Windows App
echo 📋 Building Windows app...
flutter build windows --release
if errorlevel 1 (
    echo ❌ Windows build failed
) else (
    echo ✅ Windows app built successfully
)
echo.

REM Prepare deployment files
echo 📋 Preparing deployment files...

REM Copy additional files for web deployment
if exist "web\.htaccess" (
    copy "web\.htaccess" "build\web\.htaccess" >nul 2>&1
)

if exist "web\manifest.json" (
    copy "web\manifest.json" "build\web\manifest.json" >nul 2>&1
)

REM Create build info
(
echo Build Date: %date% %time%
echo Build ID: %BUILD_ID%
echo Flutter Version: 
flutter --version | findstr "Flutter"
echo Build Mode: %FLUTTER_BUILD_MODE%
echo Web Renderer: %FLUTTER_WEB_RENDERER%
echo Platform: Windows
echo Architecture: %PROCESSOR_ARCHITECTURE%
) > build\web\build-info.txt

REM Show build sizes
echo 📋 Build sizes:
if exist "build\web" (
    for /f %%i in ('dir build\web /s /-c ^| find "File(s)"') do echo Web build size: %%i bytes
)

if exist "build\app\outputs\bundle\release" (
    for /f %%i in ('dir build\app\outputs\bundle\release\*.aab /-c ^| find "File(s)"') do echo Android AAB size: %%i bytes
)

if exist "build\app\outputs\flutter-apk" (
    for /f %%i in ('dir build\app\outputs\flutter-apk\*.apk /-c ^| find "File(s)"') do echo Android APK size: %%i bytes
)

REM Create archives
echo 📋 Creating build archives...
cd build

if exist "web" (
    powershell -command "Compress-Archive -Path web\* -DestinationPath ..\web-build-%BUILD_ID%.zip -Force"
    echo Web archive: web-build-%BUILD_ID%.zip
)

if exist "app" (
    powershell -command "Compress-Archive -Path app\* -DestinationPath ..\android-build-%BUILD_ID%.zip -Force"
    echo Android archive: android-build-%BUILD_ID%.zip
)

cd ..

echo ✅ Build archives created
echo.

REM Final summary
echo 🎉 Build completed successfully!
echo Build ID: %BUILD_ID%
echo.
echo 📁 Build artifacts:
echo   - build\web\ (Web application)
if exist "build\app\outputs\bundle\release" (
    echo   - build\app\outputs\bundle\release\*.aab (Android App Bundle)
)
if exist "build\app\outputs\flutter-apk" (
    echo   - build\app\outputs\flutter-apk\*.apk (Android APK)
)
if exist "build\windows" (
    echo   - build\windows\ (Windows application)
)
echo.
echo 📦 Archives:
dir *-build-%BUILD_ID%.zip 2>nul || echo No archives created
echo.
echo 💡 Next steps:
echo   1. Test the web build locally: cd build\web ^&^& python -m http.server 8000
echo   2. Deploy to your hosting provider
echo   3. Upload Android AAB to Google Play Console
echo   4. Upload Windows app to Microsoft Store
echo.
echo ✅ Codemagic-style build completed!

pause
