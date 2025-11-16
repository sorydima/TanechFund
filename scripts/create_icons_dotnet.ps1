# REChain VC Lab - Create Icons using .NET
Write-Host "🚀 Creating REChain VC Lab Icons" -ForegroundColor Green

# Load System.Drawing
Add-Type -AssemblyName System.Drawing

function Create-Icon {
    param(
        [string]$Path,
        [int]$Size
    )
    
    try {
        # Create bitmap
        $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        
        # Set quality
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        
        # Background color #6366F1
        $bgColor = [System.Drawing.Color]::FromArgb(99, 102, 241)
        $graphics.Clear($bgColor)
        
        # White border
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, [Math]::Max(1, $Size/16))
        $graphics.DrawRectangle($pen, 0, 0, $Size-1, $Size-1)
        
        # Add "R" text
        $font = New-Object System.Drawing.Font("Arial", [int]($Size/3), [System.Drawing.FontStyle]::Bold)
        $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        
        $text = "R"
        $textSize = $graphics.MeasureString($text, $font)
        $x = ($Size - $textSize.Width) / 2
        $y = ($Size - $textSize.Height) / 2
        $graphics.DrawString($text, $font, $brush, $x, $y)
        
        # Save PNG
        $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Cleanup
        $graphics.Dispose()
        $bitmap.Dispose()
        $pen.Dispose()
        $font.Dispose()
        $brush.Dispose()
        
        Write-Host "✅ Created: $Path ($Size x $Size)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Failed: $Path - $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Create directories
$dirs = @(
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

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "📁 Created: $dir" -ForegroundColor Cyan
    }
}

# Create icons
$icons = @(
    @{Path="android/app/src/main/res/mipmap-mdpi/ic_launcher.png"; Size=48},
    @{Path="android/app/src/main/res/mipmap-hdpi/ic_launcher.png"; Size=72},
    @{Path="android/app/src/main/res/mipmap-xhdpi/ic_launcher.png"; Size=96},
    @{Path="android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png"; Size=144},
    @{Path="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"; Size=192},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-20.png"; Size=20},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-29.png"; Size=29},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-40.png"; Size=40},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-60.png"; Size=60},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-76.png"; Size=76},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-120.png"; Size=120},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-180.png"; Size=180},
    @{Path="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png"; Size=1024},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_16x16.png"; Size=16},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_32x32.png"; Size=32},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_128x128.png"; Size=128},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_256x256.png"; Size=256},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_512x512.png"; Size=512},
    @{Path="macos/Runner/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png"; Size=1024},
    @{Path="web/favicon.png"; Size=32},
    @{Path="web/icons/Icon-192.png"; Size=192},
    @{Path="web/icons/Icon-512.png"; Size=512},
    @{Path="windows/runner/rechain_vc_lab_icon.png"; Size=256},
    @{Path="linux/icon_16x16.png"; Size=16},
    @{Path="linux/icon_32x32.png"; Size=32},
    @{Path="linux/icon_48x48.png"; Size=48},
    @{Path="linux/icon_64x64.png"; Size=64},
    @{Path="linux/icon_128x128.png"; Size=128},
    @{Path="linux/icon_256x256.png"; Size=256}
)

$success = 0
foreach ($icon in $icons) {
    if (Create-Icon -Path $icon.Path -Size $icon.Size) {
        $success++
    }
}

Write-Host "`n📊 Created $success/$($icons.Count) icons" -ForegroundColor Cyan
Write-Host "`n🚀 Run: flutter clean && flutter pub get && flutter run -d chrome" -ForegroundColor Yellow
