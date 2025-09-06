# Create simple PNG icons using PowerShell and .NET
Write-Host "🎨 Creating Simple PNG Icons" -ForegroundColor Green

# Add System.Drawing assembly
Add-Type -AssemblyName System.Drawing

# Function to create a simple PNG
function Create-PNGIcon {
    param(
        [string]$FilePath,
        [int]$Size,
        [string]$Text = "R"
    )
    
    try {
        # Create bitmap
        $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        
        # Set high quality
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
        
        # Background gradient effect (simple solid color for now)
        $bgColor = [System.Drawing.Color]::FromArgb(99, 102, 241) # #6366F1
        $graphics.Clear($bgColor)
        
        # Draw border
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 2)
        $graphics.DrawRectangle($pen, 1, 1, $Size-2, $Size-2)
        
        # Add text
        $font = New-Object System.Drawing.Font("Arial", [int]($Size/3), [System.Drawing.FontStyle]::Bold)
        $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        
        $textSize = $graphics.MeasureString($Text, $font)
        $x = ($Size - $textSize.Width) / 2
        $y = ($Size - $textSize.Height) / 2
        $graphics.DrawString($Text, $font, $brush, $x, $y)
        
        # Save PNG
        $bitmap.Save($FilePath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Cleanup
        $graphics.Dispose()
        $bitmap.Dispose()
        $pen.Dispose()
        $font.Dispose()
        $brush.Dispose()
        
        Write-Host "✅ Created: $FilePath ($Size x $Size)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Failed: $FilePath - $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Create web icons
Write-Host "🌐 Creating Web Icons..." -ForegroundColor Blue

# Ensure directory exists
if (-not (Test-Path "web/icons")) {
    New-Item -ItemType Directory -Path "web/icons" -Force | Out-Null
}

# Create icons
$icons = @(
    @{Path="web/favicon.png"; Size=32},
    @{Path="web/icons/Icon-192.png"; Size=192},
    @{Path="web/icons/Icon-512.png"; Size=512}
)

$success = 0
foreach ($icon in $icons) {
    if (Create-PNGIcon -FilePath $icon.Path -Size $icon.Size) {
        $success++
    }
}

Write-Host "`n📊 Created $success/$($icons.Count) web icons" -ForegroundColor Cyan

if ($success -gt 0) {
    Write-Host "`n🚀 Testing icons..." -ForegroundColor Yellow
    Write-Host "Run: flutter clean && flutter pub get && flutter run -d chrome" -ForegroundColor White
}
