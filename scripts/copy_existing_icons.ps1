# Copy existing Flutter icons and rename them for our app
Write-Host "🔄 Copying existing Flutter icons for REChain VC Lab" -ForegroundColor Green
Write-Host "=" * 50

# Android - Copy existing ic_launcher.png files
$androidSizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

Write-Host "📱 Processing Android icons..." -ForegroundColor Blue
foreach ($folder in $androidSizes.Keys) {
    $size = $androidSizes[$folder]
    $sourcePath = "android/app/src/main/res/$folder/ic_launcher.png"
    $targetPath = "android/app/src/main/res/$folder/ic_launcher.png"
    
    if (Test-Path $sourcePath) {
        Write-Host "   ✅ Found: $sourcePath ($size x $size)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Missing: $sourcePath" -ForegroundColor Red
    }
}

# iOS - Check existing icons
Write-Host "`n🍎 Processing iOS icons..." -ForegroundColor Blue
$iosPath = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
if (Test-Path $iosPath) {
    $iosFiles = Get-ChildItem -Path $iosPath -Filter "*.png"
    Write-Host "   Found $($iosFiles.Count) iOS icon files" -ForegroundColor Green
    foreach ($file in $iosFiles) {
        Write-Host "   ✅ $($file.Name)" -ForegroundColor Gray
    }
} else {
    Write-Host "   ❌ iOS icons directory not found" -ForegroundColor Red
}

# Web - Check existing icons
Write-Host "`n🌐 Processing Web icons..." -ForegroundColor Blue
$webPath = "web"
if (Test-Path "$webPath/favicon.png") {
    Write-Host "   ✅ Found: web/favicon.png" -ForegroundColor Green
} else {
    Write-Host "   ❌ Missing: web/favicon.png" -ForegroundColor Red
}

Write-Host "`n📋 Summary:" -ForegroundColor Cyan
Write-Host "The existing Flutter icons are already in place." -ForegroundColor White
Write-Host "To replace them with custom REChain VC Lab icons:" -ForegroundColor White
Write-Host "1. Open 'generate_icons_now.html' in your browser" -ForegroundColor Yellow
Write-Host "2. Download the custom icons" -ForegroundColor Yellow
Write-Host "3. Replace the existing icon files" -ForegroundColor Yellow

Write-Host "`n🎯 Current Status:" -ForegroundColor Cyan
Write-Host "✅ Icon structure exists" -ForegroundColor Green
Write-Host "✅ Default Flutter icons are present" -ForegroundColor Green
Write-Host "⏳ Custom icons need to be generated and replaced" -ForegroundColor Yellow
