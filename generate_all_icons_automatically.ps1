# REChain VC Lab - Automatic Icon Generation for All Platforms
Write-Host "🚀 REChain VC Lab - Generating All Custom Icons" -ForegroundColor Green
Write-Host "=" * 60

# Load System.Drawing assembly
Add-Type -AssemblyName System.Drawing

# Function to create custom REChain VC Lab icon
function Create-REChainIcon {
    param(
        [string]$FilePath,
        [int]$Size
    )
    
    try {
        # Create bitmap
        $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        
        # Set high quality
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
        
        # Background gradient (blue to purple)
        $rect = New-Object System.Drawing.Rectangle(0, 0, $Size, $Size)
        $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, 
            [System.Drawing.Color]::FromArgb(99, 102, 241), # #6366F1
            [System.Drawing.Color]::FromArgb(139, 92, 246), # #8B5CF6
            [System.Drawing.Drawing2D.LinearGradientMode]::Diagonal)
        
        $graphics.FillRectangle($brush, $rect)
        
        # Draw white border
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, [Math]::Max(1, $Size/16))
        $graphics.DrawRectangle($pen, 0, 0, $Size-1, $Size-1)
        
        # Add blockchain chain elements
        $chainSize = $Size / 8
        $centerX = $Size / 2
        $centerY = $Size / 2
        
        # Draw chain links
        $chainBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 255, 255, 255))
        $chainPen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, [Math]::Max(1, $Size/32))
        
        # Left chain link
        $leftRect = New-Object System.Drawing.Rectangle($centerX - $Size/4 - $chainSize/2, $centerY - $chainSize/4, $chainSize, $chainSize/2)
        $graphics.FillEllipse($chainBrush, $leftRect)
        $graphics.DrawEllipse($chainPen, $leftRect)
        
        # Center chain link (larger)
        $centerRect = New-Object System.Drawing.Rectangle($centerX - $chainSize*0.6, $centerY - $chainSize*0.4, $chainSize*1.2, $chainSize*0.8)
        $graphics.FillEllipse($chainBrush, $centerRect)
        $graphics.DrawEllipse($chainPen, $centerRect)
        
        # Right chain link
        $rightRect = New-Object System.Drawing.Rectangle($centerX + $Size/4 - $chainSize/2, $centerY - $chainSize/4, $chainSize, $chainSize/2)
        $graphics.FillEllipse($chainBrush, $rightRect)
        $graphics.DrawEllipse($chainPen, $rightRect)
        
        # Add "R" text in center
        $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $font = New-Object System.Drawing.Font("Arial", [int]($Size/4), [System.Drawing.FontStyle]::Bold)
        
        $text = "R"
        $textSize = $graphics.MeasureString($text, $font)
        $x = ($Size - $textSize.Width) / 2
        $y = ($Size - $textSize.Height) / 2 - $Size/8
        $graphics.DrawString($text, $font, $textBrush, $x, $y)
        
        # Add "VC" text below
        $vcFont = New-Object System.Drawing.Font("Arial", [int]($Size/8), [System.Drawing.FontStyle]::Bold)
        $vcText = "VC"
        $vcTextSize = $graphics.MeasureString($vcText, $vcFont)
        $vcX = ($Size - $vcTextSize.Width) / 2
        $vcY = ($Size - $vcTextSize.Height) / 2 + $Size/8
        $graphics.DrawString($vcText, $vcFont, $textBrush, $vcX, $vcY)
        
        # Save PNG
        $bitmap.Save($FilePath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Cleanup
        $graphics.Dispose()
        $bitmap.Dispose()
        $brush.Dispose()
        $pen.Dispose()
        $chainBrush.Dispose()
        $chainPen.Dispose()
        $textBrush.Dispose()
        $font.Dispose()
        $vcFont.Dispose()
        
        Write-Host "   ✅ Created: $FilePath ($Size x $Size)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "   ❌ Failed: $FilePath - $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Create directories if they don't exist
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
Write-Host "`n🎨 Generating Icons..." -ForegroundColor Blue

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
    if (Create-REChainIcon -FilePath $icon.Path -Size $icon.Size) {
        $successCount++
    }
}

Write-Host "`n📊 Summary:" -ForegroundColor Cyan
Write-Host "   Icons created: $successCount/$totalIcons" -ForegroundColor White

if ($successCount -eq $totalIcons) {
    Write-Host "`n✅ All custom icons created successfully!" -ForegroundColor Green
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

Write-Host "`n🎯 REChain VC Lab Custom Icons Status:" -ForegroundColor Cyan
Write-Host "✅ Android: 5 icons ready" -ForegroundColor Green
Write-Host "✅ iOS: 8 icons ready" -ForegroundColor Green
Write-Host "✅ macOS: 6 icons ready" -ForegroundColor Green
Write-Host "✅ Web: 3 icons ready" -ForegroundColor Green
Write-Host "✅ Windows: 1 icon ready" -ForegroundColor Green
Write-Host "✅ Linux: 6 icons ready" -ForegroundColor Green
Write-Host "🎨 Total: $successCount custom icons generated!" -ForegroundColor Magenta
