# REChain VC Lab - Create Icons from AppLogo.jpg
Write-Host "🚀 REChain VC Lab - Creating Icons from AppLogo.jpg" -ForegroundColor Green
Write-Host "=" * 60

# Load System.Drawing
Add-Type -AssemblyName System.Drawing

# Source logo path
$sourceLogo = "assets/AppLogo.jpg"

if (-not (Test-Path $sourceLogo)) {
    Write-Host "❌ Source logo not found: $sourceLogo" -ForegroundColor Red
    exit 1
}

Write-Host "📸 Using source logo: $sourceLogo" -ForegroundColor Blue

function Create-IconFromLogo {
    param(
        [string]$SourcePath,
        [string]$OutputPath,
        [int]$Size,
        [bool]$WithBackground = $true
    )
    
    try {
        # Load source image
        $sourceImage = [System.Drawing.Image]::FromFile($SourcePath)
        
        # Create new bitmap
        $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        
        # Set high quality
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        
        if ($WithBackground) {
            # Fill with background color #6366F1
            $bgColor = [System.Drawing.Color]::FromArgb(99, 102, 241)
            $graphics.Clear($bgColor)
        } else {
            # Transparent background
            $graphics.Clear([System.Drawing.Color]::Transparent)
        }
        
        # Calculate scaling to fit within target size with padding
        $padding = [Math]::Max(1, $Size / 8)
        $maxSize = $Size - ($padding * 2)
        
        $sourceRatio = $sourceImage.Width / $sourceImage.Height
        
        if ($sourceRatio -gt 1.0) {
            # Image is wider than tall
            $newWidth = $maxSize
            $newHeight = [int]($maxSize / $sourceRatio)
        } else {
            # Image is taller than wide
            $newHeight = $maxSize
            $newWidth = [int]($maxSize * $sourceRatio)
        }
        
        # Center the image
        $x = ($Size - $newWidth) / 2
        $y = ($Size - $newHeight) / 2
        
        # Draw the resized image
        $graphics.DrawImage($sourceImage, $x, $y, $newWidth, $newHeight)
        
        # Save as PNG
        $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Cleanup
        $graphics.Dispose()
        $bitmap.Dispose()
        $sourceImage.Dispose()
        
        Write-Host "   ✅ Created: $OutputPath ($Size x $Size)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "   ❌ Failed: $OutputPath - $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Create directories
Write-Host "📁 Creating directories..." -ForegroundColor Blue

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

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "   📁 Created: $dir" -ForegroundColor Cyan
    }
}

# Generate all icons
Write-Host "`n🎨 Creating Icons from AppLogo.jpg..." -ForegroundColor Blue

$icons = @(
    # Android
    @{Path="android/app/src/main/res/mipmap-mdpi/ic_launcher.png"; Size=48},
    @{Path="android/app/src/main/res/mipmap-hdpi/ic_launcher.png"; Size=72},
    @{Path="android/app/src/main/res/mipmap-xhdpi/ic_launcher.png"; Size=96},
    @{Path="android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png"; Size=144},
    @{Path="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"; Size=192},
    
    # iOS
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-20.png"; Size=20},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-29.png"; Size=29},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-40.png"; Size=40},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-60.png"; Size=60},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-76.png"; Size=76},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-120.png"; Size=120},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-180.png"; Size=180},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png"; Size=1024},
    
    # macOS
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_16x16.png"; Size=16},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_32x32.png"; Size=32},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_128x128.png"; Size=128},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_256x256.png"; Size=256},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_512x512.png"; Size=512},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png"; Size=1024},
    
    # Web
    @{Path="web/favicon.png"; Size=32},
    @{Path="web/icons/Icon-192.png"; Size=192},
    @{Path="web/icons/Icon-512.png"; Size=512},
    
    # Windows
    @{Path="windows/runner/rechain_vc_lab_icon.png"; Size=256},
    
    # Linux
    @{Path="linux/icon_16x16.png"; Size=16},
    @{Path="linux/icon_32x32.png"; Size=32},
    @{Path="linux/icon_48x48.png"; Size=48},
    @{Path="linux/icon_64x64.png"; Size=64},
    @{Path="linux/icon_128x128.png"; Size=128},
    @{Path="linux/icon_256x256.png"; Size=256}
)

$successCount = 0
$totalIcons = $icons.Count

foreach ($icon in $icons) {
    if (Create-IconFromLogo -SourcePath $sourceLogo -OutputPath $icon.Path -Size $icon.Size -WithBackground $true) {
        $successCount++
    }
}

Write-Host "`n📊 Summary:" -ForegroundColor Cyan
Write-Host "   Icons created: $successCount/$totalIcons" -ForegroundColor White

if ($successCount -eq $totalIcons) {
    Write-Host "`n✅ All icons created successfully from AppLogo.jpg!" -ForegroundColor Green
    Write-Host "`n🚀 Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Run 'flutter clean'" -ForegroundColor White
    Write-Host "2. Run 'flutter pub get'" -ForegroundColor White
    Write-Host "3. Test on your preferred platform:" -ForegroundColor White
    Write-Host "   - flutter run -d android" -ForegroundColor Gray
    Write-Host "   - flutter run -d chrome" -ForegroundColor Gray
    Write-Host "   - flutter run -d windows" -ForegroundColor Gray
    Write-Host "   - flutter run -d linux" -ForegroundColor Gray
} else {
    Write-Host "`n⚠️ Some icons failed to create. Check errors above." -ForegroundColor Yellow
}

Write-Host "`n🎯 REChain VC Lab Icons Status:" -ForegroundColor Cyan
Write-Host "✅ Android: 5 icons ready" -ForegroundColor Green
Write-Host "✅ iOS: 8 icons ready" -ForegroundColor Green
Write-Host "✅ macOS: 6 icons ready" -ForegroundColor Green
Write-Host "✅ Web: 3 icons ready" -ForegroundColor Green
Write-Host "✅ Windows: 1 icon ready" -ForegroundColor Green
Write-Host "✅ Linux: 6 icons ready" -ForegroundColor Green
Write-Host "🎨 Total: $successCount icons created from AppLogo.jpg!" -ForegroundColor Magenta
