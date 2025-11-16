# PowerShell script to generate icons automatically
Write-Host "🚀 Generating REChain VC Lab Icons Automatically" -ForegroundColor Green
Write-Host "=" * 60

# Check if we have the SVG file
$svgPath = "assets/icons/rechain_vc_lab_icon.svg"
if (-not (Test-Path $svgPath)) {
    Write-Host "❌ SVG file not found: $svgPath" -ForegroundColor Red
    Write-Host "Please make sure the SVG file exists before running this script." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found SVG file: $svgPath" -ForegroundColor Green

# Create directories if they don't exist
$directories = @(
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

Write-Host "📁 Creating directories..." -ForegroundColor Blue
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "   Created: $dir" -ForegroundColor Gray
    } else {
        Write-Host "   Exists: $dir" -ForegroundColor Gray
    }
}

# Define icon sizes and their target paths
$iconConfigs = @(
    # Android
    @{Size=48; Path="android/app/src/main/res/mipmap-mdpi/ic_launcher.png"},
    @{Size=72; Path="android/app/src/main/res/mipmap-hdpi/ic_launcher.png"},
    @{Size=96; Path="android/app/src/main/res/mipmap-xhdpi/ic_launcher.png"},
    @{Size=144; Path="android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png"},
    @{Size=192; Path="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"},
    
    # iOS
    @{Size=20; Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-20.png"},
    @{Size=29; Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-29.png"},
    @{Size=40; Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-40.png"},
    @{Size=60; Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-60.png"},
    @{Size=76; Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-76.png"},
    @{Size=120; Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-120.png"},
    @{Size=180; Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-180.png"},
    @{Size=1024; Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png"},
    
    # macOS
    @{Size=16; Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_16x16.png"},
    @{Size=32; Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_32x32.png"},
    @{Size=128; Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_128x128.png"},
    @{Size=256; Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_256x256.png"},
    @{Size=512; Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_512x512.png"},
    @{Size=1024; Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png"},
    
    # Web
    @{Size=32; Path="web/favicon.png"},
    @{Size=192; Path="web/icons/Icon-192.png"},
    @{Size=512; Path="web/icons/Icon-512.png"},
    
    # Windows
    @{Size=256; Path="windows/runner/rechain_vc_lab_icon.png"},
    
    # Linux
    @{Size=16; Path="linux/icon_16x16.png"},
    @{Size=32; Path="linux/icon_32x32.png"},
    @{Size=48; Path="linux/icon_48x48.png"},
    @{Size=64; Path="linux/icon_64x64.png"},
    @{Size=128; Path="linux/icon_128x128.png"},
    @{Size=256; Path="linux/icon_256x256.png"}
)

Write-Host "🎨 Generating icons..." -ForegroundColor Blue
Write-Host "Note: This script creates placeholder files. For actual PNG generation," -ForegroundColor Yellow
Write-Host "please use the generate_icons_now.html file in your browser." -ForegroundColor Yellow

$generatedCount = 0
foreach ($config in $iconConfigs) {
    $size = $config.Size
    $path = $config.Path
    
    # Create a simple placeholder file with the correct name
    # In a real implementation, you would convert SVG to PNG here
    $placeholderContent = "Placeholder for $size x $size icon. Replace with actual PNG file."
    
    try {
        # Ensure directory exists
        $dir = Split-Path $path -Parent
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        
        # Create placeholder file
        Set-Content -Path $path -Value $placeholderContent -Force
        Write-Host "   ✅ Created: $path ($size x $size)" -ForegroundColor Green
        $generatedCount++
    }
    catch {
        Write-Host "   ❌ Failed: $path - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n📊 Summary:" -ForegroundColor Cyan
Write-Host "   Total icons configured: $($iconConfigs.Count)" -ForegroundColor White
Write-Host "   Successfully created: $generatedCount" -ForegroundColor White

Write-Host "`n🚀 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Open 'generate_icons_now.html' in your web browser" -ForegroundColor White
Write-Host "2. Click 'Download All Icons' to get real PNG files" -ForegroundColor White
Write-Host "3. Replace the placeholder files with downloaded PNG files" -ForegroundColor White
Write-Host "4. Run 'flutter clean' and rebuild your project" -ForegroundColor White

Write-Host "`n📁 File locations:" -ForegroundColor Cyan
Write-Host "   HTML Generator: generate_icons_now.html" -ForegroundColor White
Write-Host "   SVG Source: assets/icons/rechain_vc_lab_icon.svg" -ForegroundColor White

Write-Host "`n🎉 Icon generation setup complete!" -ForegroundColor Green
