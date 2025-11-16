# Create PNG icons for web using PowerShell and .NET
Write-Host "🌐 Creating Web PNG Icons" -ForegroundColor Green

# Load System.Drawing
Add-Type -AssemblyName System.Drawing

function Create-WebIcon {
    param(
        [string]$Path,
        [int]$Size
    )
    
    try {
        # Create bitmap
        $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        
        # High quality
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
        
        # Background color #6366F1
        $bgColor = [System.Drawing.Color]::FromArgb(99, 102, 241)
        $graphics.Clear($bgColor)
        
        # White border
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, [Math]::Max(1, $Size/16))
        $graphics.DrawRectangle($pen, 0, 0, $Size-1, $Size-1)
        
        # White "R" text
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

# Create web/icons directory
if (-not (Test-Path "web/icons")) {
    New-Item -ItemType Directory -Path "web/icons" -Force | Out-Null
}

# Create web icons
$webIcons = @(
    @{Path="web/favicon.png"; Size=32},
    @{Path="web/icons/Icon-192.png"; Size=192},
    @{Path="web/icons/Icon-512.png"; Size=512}
)

$success = 0
foreach ($icon in $webIcons) {
    if (Create-WebIcon -Path $icon.Path -Size $icon.Size) {
        $success++
    }
}

Write-Host "`n📊 Created $success/$($webIcons.Count) web icons" -ForegroundColor Cyan

if ($success -gt 0) {
    Write-Host "`n🚀 Web icons ready! Test with:" -ForegroundColor Yellow
    Write-Host "flutter clean && flutter pub get && flutter run -d chrome" -ForegroundColor White
} else {
    Write-Host "`n⚠️ Use generate_web_icons.html in browser as alternative" -ForegroundColor Yellow
}
