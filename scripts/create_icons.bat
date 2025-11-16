@echo off
echo Creating REChain VC Lab Icons from AppLogo.jpg

REM Create directories
mkdir "ios\Runner\Assets.xcassets\AppIcon.appiconset" 2>nul
mkdir "macos\Runner\Assets.xcassets\AppIcon.appiconset" 2>nul
mkdir "web\icons" 2>nul
mkdir "windows\runner" 2>nul
mkdir "linux" 2>nul

REM Copy logo to all icon locations
copy "assets\AppLogo.jpg" "android\app\src\main\res\mipmap-mdpi\ic_launcher.png"
copy "assets\AppLogo.jpg" "android\app\src\main\res\mipmap-hdpi\ic_launcher.png"
copy "assets\AppLogo.jpg" "android\app\src\main\res\mipmap-xhdpi\ic_launcher.png"
copy "assets\AppLogo.jpg" "android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png"
copy "assets\AppLogo.jpg" "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png"

copy "assets\AppLogo.jpg" "ios\Runner\Assets.xcassets\AppIcon.appiconset\icon-20.png"
copy "assets\AppLogo.jpg" "ios\Runner\Assets.xcassets\AppIcon.appiconset\icon-29.png"
copy "assets\AppLogo.jpg" "ios\Runner\Assets.xcassets\AppIcon.appiconset\icon-40.png"
copy "assets\AppLogo.jpg" "ios\Runner\Assets.xcassets\AppIcon.appiconset\icon-60.png"
copy "assets\AppLogo.jpg" "ios\Runner\Assets.xcassets\AppIcon.appiconset\icon-76.png"
copy "assets\AppLogo.jpg" "ios\Runner\Assets.xcassets\AppIcon.appiconset\icon-120.png"
copy "assets\AppLogo.jpg" "ios\Runner\Assets.xcassets\AppIcon.appiconset\icon-180.png"
copy "assets\AppLogo.jpg" "ios\Runner\Assets.xcassets\AppIcon.appiconset\icon-1024.png"

copy "assets\AppLogo.jpg" "macos\Runner\Assets.xcassets\AppIcon.appiconset\icon_16x16.png"
copy "assets\AppLogo.jpg" "macos\Runner\Assets.xcassets\AppIcon.appiconset\icon_32x32.png"
copy "assets\AppLogo.jpg" "macos\Runner\Assets.xcassets\AppIcon.appiconset\icon_128x128.png"
copy "assets\AppLogo.jpg" "macos\Runner\Assets.xcassets\AppIcon.appiconset\icon_256x256.png"
copy "assets\AppLogo.jpg" "macos\Runner\Assets.xcassets\AppIcon.appiconset\icon_512x512.png"
copy "assets\AppLogo.jpg" "macos\Runner\Assets.xcassets\AppIcon.appiconset\icon_1024x1024.png"

copy "assets\AppLogo.jpg" "web\favicon.png"
copy "assets\AppLogo.jpg" "web\icons\Icon-192.png"
copy "assets\AppLogo.jpg" "web\icons\Icon-512.png"

copy "assets\AppLogo.jpg" "windows\runner\rechain_vc_lab_icon.png"

copy "assets\AppLogo.jpg" "linux\icon_16x16.png"
copy "assets\AppLogo.jpg" "linux\icon_32x32.png"
copy "assets\AppLogo.jpg" "linux\icon_48x48.png"
copy "assets\AppLogo.jpg" "linux\icon_64x64.png"
copy "assets\AppLogo.jpg" "linux\icon_128x128.png"
copy "assets\AppLogo.jpg" "linux\icon_256x256.png"

echo.
echo All icons created successfully!
echo.
echo Next steps:
echo 1. Run: flutter clean
echo 2. Run: flutter pub get
echo 3. Run: flutter run -d chrome
echo.
pause
