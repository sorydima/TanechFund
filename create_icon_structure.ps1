# PowerShell script to create icon structure for REChain VC Lab
Write-Host "Creating custom icon structure for REChain VC Lab" -ForegroundColor Green
Write-Host "=" * 50

# Check if SVG file exists
$svgPath = "assets/icons/rechain_vc_lab_icon.svg"
if (-not (Test-Path $svgPath)) {
    Write-Host "SVG file not found: $svgPath" -ForegroundColor Red
    exit 1
}

Write-Host "Source SVG file: $svgPath" -ForegroundColor Blue

# Create directories for icons
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
        Write-Host "Created folder: $folder" -ForegroundColor Yellow
    }
}

Write-Host "All folders created successfully" -ForegroundColor Green

# Create placeholder files to show structure
Write-Host "Creating placeholder files..." -ForegroundColor Blue

# Android icons
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
    Write-Host "Placeholder: $outputPath ($size x $size)" -ForegroundColor Cyan
    # Copy SVG as placeholder (will be replaced with actual PNG)
    Copy-Item $svgPath $outputPath -Force
}

# iOS icons
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
    Write-Host "Placeholder: $outputPath ($size x $size)" -ForegroundColor Cyan
    Copy-Item $svgPath $outputPath -Force
}

# Web icons
$webSizes = @{
    "Icon-192.png" = 192
    "Icon-512.png" = 512
    "Icon-maskable-192.png" = 192
    "Icon-maskable-512.png" = 512
}

foreach ($filename in $webSizes.Keys) {
    $size = $webSizes[$filename]
    $outputPath = "web/icons/$filename"
    Write-Host "Placeholder: $outputPath ($size x $size)" -ForegroundColor Cyan
    Copy-Item $svgPath $outputPath -Force
}

# Windows icons
Write-Host "Placeholder: windows/runner/rechain_vc_lab_icon.png (256 x 256)" -ForegroundColor Cyan
Copy-Item $svgPath "windows/runner/rechain_vc_lab_icon.png" -Force

# macOS icons
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
    Write-Host "Placeholder: $outputPath ($size x $size)" -ForegroundColor Cyan
    Copy-Item $svgPath $outputPath -Force
}

# Linux icons
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
    Write-Host "Placeholder: $outputPath ($size x $size)" -ForegroundColor Cyan
    Copy-Item $svgPath $outputPath -Force
}

Write-Host "`nIcon structure created successfully!" -ForegroundColor Green
Write-Host "=" * 50
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Use online SVG to PNG converter to create actual icons" -ForegroundColor White
Write-Host "2. Or install Python and run generate_icons.py" -ForegroundColor White
Write-Host "3. Remove old standard icons" -ForegroundColor White
Write-Host "4. Update configuration files" -ForegroundColor White
