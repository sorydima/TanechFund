# Создание минимальных иконок для Android
# Используем .NET для создания простых PNG файлов

Add-Type -AssemblyName System.Drawing

function Create-MinimalIcon {
    param(
        [int]$Size,
        [string]$OutputPath
    )
    
    # Создаем bitmap
    $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Очищаем фон
    $graphics.Clear([System.Drawing.Color]::Transparent)
    
    # Рисуем простой круг
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Blue)
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::DarkBlue, 2)
    
    $margin = $Size / 8
    $graphics.FillEllipse($brush, $margin, $margin, $Size - 2*$margin, $Size - 2*$margin)
    $graphics.DrawEllipse($pen, $margin, $margin, $Size - 2*$margin, $Size - 2*$margin)
    
    # Добавляем текст
    $font = New-Object System.Drawing.Font("Arial", $Size/4, [System.Drawing.FontStyle]::Bold)
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    
    $text = "RC"
    $textSize = $graphics.MeasureString($text, $font)
    $x = ($Size - $textSize.Width) / 2
    $y = ($Size - $textSize.Height) / 2
    
    $graphics.DrawString($text, $font, $textBrush, $x, $y)
    
    # Сохраняем как PNG
    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Освобождаем ресурсы
    $graphics.Dispose()
    $bitmap.Dispose()
    $brush.Dispose()
    $pen.Dispose()
    $font.Dispose()
    $textBrush.Dispose()
    
    Write-Host "Создана иконка: $OutputPath ($Size x $Size)"
}

# Размеры иконок
$iconSizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

# Создаем иконки
foreach ($folder in $iconSizes.Keys) {
    $folderPath = "android\app\src\main\res\$folder"
    if (-not (Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath -Force
    }
    
    $outputPath = "$folderPath\ic_launcher.png"
    Create-MinimalIcon -Size $iconSizes[$folder] -OutputPath $outputPath
}

Write-Host "Все иконки созданы успешно!" -ForegroundColor Green

