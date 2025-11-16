@echo off
echo Starting REChain VC Group Lab Flutter App...
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

REM Show available devices
echo Available devices:
flutter devices
echo.

REM Run the app
echo Starting the app...
echo Press 'r' to hot reload, 'R' to hot restart, 'q' to quit
flutter run

pause
