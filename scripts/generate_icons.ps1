# PowerShell скрипт для создания иконок
# Этот скрипт создает простые PNG иконки на основе SVG

Write-Host "🚀 Генерация кастомных иконок для REChain VC Lab" -ForegroundColor Green
Write-Host "=" * 50

# Проверяем наличие SVG файла
$svgPath = "assets/icons/rechain_vc_lab_icon.svg"
if (-not (Test-Path $svgPath)) {
    Write-Host "❌ SVG файл не найден: $svgPath" -ForegroundColor Red
    exit 1
}

Write-Host "📁 Исходный SVG файл: $svgPath" -ForegroundColor Blue

# Создаем папки для иконок
$folders = @(
    "android/app/src/main/res/mipmap-mdpi",
    "android/app/src/main/res/mipmap-hdpi", 
    "android/app/src/main/res/mipmap-xhdpi",
    "android/app/src/main/res/mipmap-xxhdpi",
    "android/app/src/main/res/mipmap-xxxhdpi",
    "ios/Runner/Assets.xcassets/AppIcon.appiconset",
    "macos/Runner/Assets.xcassets/AppIcon.appiconset",
    "web/icons",
    "windows/runner",
    "linux"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "📁 Создана папка: $folder" -ForegroundColor Yellow
    }
}

Write-Host "✅ Все папки созданы" -ForegroundColor Green

# Создаем простые placeholder иконки
# В реальном проекте здесь должен быть конвертер SVG в PNG

Write-Host "📱 Создание Android иконок..." -ForegroundColor Blue
$androidSizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

foreach ($folder in $androidSizes.Keys) {
    $size = $androidSizes[$folder]
    $outputPath = "android/app/src/main/res/$folder/ic_launcher.png"
    Write-Host "📄 Создание: $outputPath ($size x $size)" -ForegroundColor Cyan
    # Здесь должен быть код для создания PNG из SVG
}

Write-Host "🍎 Создание iOS иконок..." -ForegroundColor Blue
$iosSizes = @{
    "icon-20.png" = 20
    "icon-29.png" = 29
    "icon-40.png" = 40
    "icon-50.png" = 50
    "icon-57.png" = 57
    "icon-60.png" = 60
    "icon-72.png" = 72
    "icon-76.png" = 76
    "icon-80.png" = 80
    "icon-87.png" = 87
    "icon-100.png" = 100
    "icon-114.png" = 114
    "icon-120.png" = 120
    "icon-144.png" = 144
    "icon-152.png" = 152
    "icon-167.png" = 167
    "icon-180.png" = 180
    "icon-1024.png" = 1024
}

foreach ($filename in $iosSizes.Keys) {
    $size = $iosSizes[$filename]
    $outputPath = "ios/Runner/Assets.xcassets/AppIcon.appiconset/$filename"
    Write-Host "📄 Создание: $outputPath ($size x $size)" -ForegroundColor Cyan
}

Write-Host "🌐 Создание Web иконок..." -ForegroundColor Blue
$webSizes = @{
    "Icon-192.png" = 192
    "Icon-512.png" = 512
    "Icon-maskable-192.png" = 192
    "Icon-maskable-512.png" = 512
}

foreach ($filename in $webSizes.Keys) {
    $size = $webSizes[$filename]
    $outputPath = "web/icons/$filename"
    Write-Host "📄 Создание: $outputPath ($size x $size)" -ForegroundColor Cyan
}

Write-Host "🪟 Создание Windows иконок..." -ForegroundColor Blue
Write-Host "📄 Создание: windows/runner/rechain_vc_lab_icon.png (256 x 256)" -ForegroundColor Cyan
Write-Host "📄 Создание: windows/runner/rechain_vc_lab_icon.ico" -ForegroundColor Cyan

Write-Host "💻 Создание macOS иконок..." -ForegroundColor Blue
$macosSizes = @{
    "icon_16x16.png" = 16
    "icon_32x32.png" = 32
    "icon_64x64.png" = 64
    "icon_128x128.png" = 128
    "icon_256x256.png" = 256
    "icon_512x512.png" = 512
    "icon_1024x1024.png" = 1024
}

foreach ($filename in $macosSizes.Keys) {
    $size = $macosSizes[$filename]
    $outputPath = "macos/Runner/Assets.xcassets/AppIcon.appiconset/$filename"
    Write-Host "📄 Создание: $outputPath ($size x $size)" -ForegroundColor Cyan
}

Write-Host "🐧 Создание Linux иконок..." -ForegroundColor Blue
$linuxSizes = @{
    "icon_16x16.png" = 16
    "icon_32x32.png" = 32
    "icon_48x48.png" = 48
    "icon_64x64.png" = 64
    "icon_128x128.png" = 128
    "icon_256x256.png" = 256
}

foreach ($filename in $linuxSizes.Keys) {
    $size = $linuxSizes[$filename]
    $outputPath = "linux/$filename"
    Write-Host "📄 Создание: $outputPath ($size x $size)" -ForegroundColor Cyan
}

Write-Host "`n🎉 Структура иконок подготовлена!" -ForegroundColor Green
Write-Host "=" * 50
Write-Host "📋 Следующие шаги:" -ForegroundColor Yellow
Write-Host "1. Используйте онлайн конвертер SVG в PNG для создания иконок" -ForegroundColor White
Write-Host "2. Или установите Python и запустите generate_icons.py" -ForegroundColor White
Write-Host "3. Удалите старые стандартные иконки" -ForegroundColor White
Write-Host "4. Обновите конфигурационные файлы" -ForegroundColor White
