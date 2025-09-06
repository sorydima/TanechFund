# PowerShell скрипт для создания иконок Android
# Копируем AppLogo.jpg в папки иконок Android

$sourceImage = "assets\AppLogo.jpg"

# Проверяем, что исходный файл существует
if (-not (Test-Path $sourceImage)) {
    Write-Host "Ошибка: файл $sourceImage не найден!" -ForegroundColor Red
    exit 1
}

# Размеры иконок для разных плотностей экрана
$iconSizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

# Создаем иконки для каждой плотности
foreach ($folder in $iconSizes.Keys) {
    $folderPath = "android\app\src\main\res\$folder"
    $outputPath = "$folderPath\ic_launcher.png"
    
    # Создаем папку если не существует
    if (-not (Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath -Force
    }
    
    # Копируем файл (временно просто копируем, без изменения размера)
    Copy-Item $sourceImage $outputPath -Force
    Write-Host "Скопирована иконка: $outputPath" -ForegroundColor Green
}

Write-Host "Все иконки Android созданы!" -ForegroundColor Green

